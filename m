Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFEED7F1D
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 20:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389170AbfJOSfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 14:35:00 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:44408 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfJOSfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 14:35:00 -0400
Received: by mail-qt1-f169.google.com with SMTP id u40so31984301qth.11
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 11:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=STXoJpha5c0eU0zUp+Q7GhRDc2v/wNfJM9Q0lsQru9I=;
        b=aDz7CFO7/eeyag+DWLYTXxSS73mm6K5E7SozNF95XjKVAj8Od28EBX/kbBzlHSR5N4
         4iqMcXCnXdMzpqkPZh2z6/SXXCFI5UrhpdHThob7EQRiKAmwcc/OgOSJ7reTlwZWxsZ1
         4YXZuQPvngoRbpZVPYLwSh5vx0fcol0RM6GUs4tC15WzioRfmnE3j8KLWmVN0LoyikyX
         48bmrgWisCS+9iOijHV/tRFGiJ9XhUOQIB0GkUQbCpZ2EhJpiIXyCjUMqtrCBL6SexAE
         ts0y4NdVTmwqjrG9hf2m632EB/rCzrKdMwlIvT5LGmG6iNAYVdal3/5DxXwyInyHgowG
         +pFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=STXoJpha5c0eU0zUp+Q7GhRDc2v/wNfJM9Q0lsQru9I=;
        b=mV7LNHAhA92SNhvbPpAgNNNEqDe3//HseJGodc7ukb7IVThxufOb7MplFR1+WONMq0
         O/07RmTmNAOCy7oCcg0VNZdZtSnHwN/DVZqFHikTHBM+w+ayz3FObuhZfJk7ilxs70YQ
         50M9O9GM+7FN+A5Nokmfi63iRImRf/zwjsp5CIemD/ReOtzVWvXvwctE/hPcwhjfF0Ti
         phNSV9R/ffBU59/bW2RZmiCltCul3J2aqPZfjYH39yl0PLWeRdG7e8CjezWJF8u8xaUb
         P+AAIme81jnQiuyZ6N8vRUAwr+ir76sFZGInFFkl7iJr+VthTEMzMNwGY/HY2Ap7UJGr
         PMiw==
X-Gm-Message-State: APjAAAW5hLpaxvN6tOlkEOQ5QYFreQp9ynYwe5EaEm6gepg+T09evTXB
        CFKlqHS0SsDsSEIeQU7TWVk=
X-Google-Smtp-Source: APXvYqznj8QlNJ6TJ4JgSis29qEtI41ZMjjJegT6R3eRa1NWe3fg8Op+RtRdSDoh/7EaJwN11o+ACQ==
X-Received: by 2002:ac8:154:: with SMTP id f20mr40504004qtg.367.1571164499579;
        Tue, 15 Oct 2019 11:34:59 -0700 (PDT)
Received: from dahern-DO-MB.local (207.190.24.244.psav-cs.smartcity.net. [207.190.24.244])
        by smtp.googlemail.com with ESMTPSA id y22sm11092596qka.59.2019.10.15.11.34.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 11:34:58 -0700 (PDT)
Subject: Re: [patch iproute2-next v3 2/2] ip: allow to use alternative names
 as handle
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        stephen@networkplumber.org, roopa@cumulusnetworks.com,
        dcbw@redhat.com, nikolay@cumulusnetworks.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        f.fainelli@gmail.com, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
References: <20191009124947.27175-1-jiri@resnulli.us>
 <20191009124947.27175-3-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f0693559-1ba2-ea6c-a36a-ef9146e1ba9b@gmail.com>
Date:   Tue, 15 Oct 2019 14:34:56 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191009124947.27175-3-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/19 8:49 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Extend ll_name_to_index() to get the index of a netdevice using
> alternative interface name. Allow alternative long names to pass checks
> in couple of ip link/addr commands.

you don't add altnames to the name_hash, so the lookup can not find a
match based on altname.

