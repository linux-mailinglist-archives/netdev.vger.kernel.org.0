Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B3E467C27
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 18:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239612AbhLCRFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 12:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbhLCRFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 12:05:13 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90225C061354
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 09:01:48 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id n66so6924164oia.9
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 09:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tbEwySXb6yGxG6N7AFD65uHpUF9qIsmwiRZG3EFyfoQ=;
        b=d9FGTw97nQD8RVohATVwa6tURsiCtdhyWxDCP+26+2Ikkr/XRh+pPSWCpeCH4rnVYB
         oGUBk4yopd0Z2OEEVwiP6lupdhrTzce9hz+z6ulzORp22FeRLLgxy7Qwt7Ir/tlNU8UF
         PX5IeZYu+ttbrZXG/yR0aT9/nYTAQZLkzBoUEPi38eMUUHove2S0H1Ur2ktHHBn1mDVw
         tSUr0UrwAqJOC0zj0ruLb3Rije4TpUP+E2xxIxDanNTN9MH3lBPNANxZJs9WEePWjb/e
         wwfLzWtMjNbobR2ybnomh9q+0ZFKzDfTwQYP8v04m6zlboke0kD5otrmDN2uvbTCKbUm
         Ts7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tbEwySXb6yGxG6N7AFD65uHpUF9qIsmwiRZG3EFyfoQ=;
        b=48qN+4EnRTdDf7NURvXVhGzU+5T9EA2t14h027AWKVr5PM3uU8BsvoCK4NYYgc6d3H
         8886dE/jNIYxAxaoej5sLW9zmLbzM0BtZywj5AwSg5rInHF8Tw7c3xizKUYEAnwuVElW
         Xe+irddUuffU6OuqjOm5otGe8Mh9LdWUKlF69qZ4brue3xS0EUQDTC6YHK1PWG+mf98j
         Fucf+tHq3ZsEynf8os+64BUso608703bc6J3o0FeD6BfhSj49C5G4bcqHys1A1qzhd5R
         daXki35Q8nFaeBXq6+TKKKWK3VQyqfdUI0TeI+LPbaVOZVQYJxUEQCQK313psFWhOLvy
         8qCQ==
X-Gm-Message-State: AOAM532+ytUNSaqw05SQz8Ji27/A59U/qJK5EEjZD+f32B5bwXatL5NI
        9pKP5LNxoDBnQhetsERdQlI=
X-Google-Smtp-Source: ABdhPJwA0bZvUL3WcE1oyAKNlsn3/8Ee5b6FzsxNUmDJeKAM1vTb6I7OCxXwldT3drUiGwTyvxNX4w==
X-Received: by 2002:a05:6808:aa7:: with SMTP id r7mr10976017oij.120.1638550907915;
        Fri, 03 Dec 2021 09:01:47 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id 69sm704731otf.33.2021.12.03.09.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 09:01:47 -0800 (PST)
Message-ID: <778b1eb5-3f46-2489-4de8-17fda15d3dd5@gmail.com>
Date:   Fri, 3 Dec 2021 10:01:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [iproute2-next 4/4] vdpa: Enable user to set mtu of the vdpa
 device
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, mst@redhat.com,
        jasowang@redhat.com
References: <20211202042239.2454-1-parav@nvidia.com>
 <20211202042239.2454-5-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211202042239.2454-5-parav@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 9:22 PM, Parav Pandit wrote:
> @@ -154,6 +156,31 @@ static int vdpa_argv_mac(struct vdpa *vdpa, int argc, char **argv, char *mac)
>  	return 0;
>  }
>  
> +static int strtouint16_t(const char *str, uint16_t *p_val)
> +{
> +	char *endptr;
> +	unsigned long int val;
> +
> +	val = strtoul(str, &endptr, 10);
> +	if (endptr == str || *endptr != '\0')
> +		return -EINVAL;
> +	if (val > USHRT_MAX)
> +		return -ERANGE;
> +	*p_val = val;
> +	return 0;
> +}

duplicates get_u16
