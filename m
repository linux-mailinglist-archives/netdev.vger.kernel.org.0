Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B592815C832
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgBMQ0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 11:26:46 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40136 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbgBMQ0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 11:26:46 -0500
Received: by mail-pj1-f66.google.com with SMTP id 12so2627149pjb.5
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 08:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VWpD/oSC/9lwwBJJFvh9A77mCFIdYRk2VVCD/TRAJxA=;
        b=nlrHdafi0puXsV7lraciQQQUdOxTObP5STkchE2xLZOUinTPAT+d3CKxJXQphQ17rE
         NjwFGlly4ylistT7fdf0beA/V9/z0Iw2Y+bpqq+X6HsACxj9gPz9m0G2ivxmpJHguZva
         tLIhagCJYkR1p9enfbIYzsmznnAVy9r3xIR21RyDxhZTRwL+JUjZbpnMUx6AjwWfiqWK
         qje3Uhqokfaseq9gXNJrbTJYyHjfmeBpYU0lbNegThZawUV/tmCS+vQai93FLrc33PRa
         IvyGsFnTLJaxW197dLAcz+1rkepBP1e9PmnyK8YjNtsum6XkPHHG1o/AnNruDCjxaSln
         gqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VWpD/oSC/9lwwBJJFvh9A77mCFIdYRk2VVCD/TRAJxA=;
        b=FYLkgELX8RFiHxgN/h16u3eYxSaPc6e0Sw7v451ZfIiwCRaCZRbqvihLs74azmwYSd
         wKeaK3hjaGs3ceNARtIm7VvV+1Dv2B34ZJ0tR5badkjEi99LLp+2quJ264yI1uHanbrk
         HQ8qhkhhOGZ5QEyXmDN0dqw5COT+ZmSbBco0caUeaHIssTc6TQbcFTEKIEJlTmCMxQTX
         +n3HiQcEBa25BHAlL92xbNS+Q5OlotVA6iiyj1r/76MT45uqCjnMmPqkCTs4kr9QlKuj
         c2vSkh1s4lQNC8Az6A0pnQCz6FvAbNGj3xx8OeTgNc2L8W+B+325AxjhvWMQB+Ym8dht
         jPig==
X-Gm-Message-State: APjAAAUmcHZ+idI6lOO2Jr1701BLa1hTiaevSdkBjrcl5nWwckzJ/72R
        1vGhrSN/1z6r16ZTpIV8Z6dtUA==
X-Google-Smtp-Source: APXvYqwDZmQbbtFjm0mg+V5ys0hdJrGtAhB1jG8Lk0w+Ow3W1sLrykqNDRGdyINrQfmfPVef9y/gZg==
X-Received: by 2002:a17:902:ff16:: with SMTP id f22mr13742773plj.229.1581611205102;
        Thu, 13 Feb 2020 08:26:45 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id ci5sm3231289pjb.5.2020.02.13.08.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 08:26:44 -0800 (PST)
Date:   Thu, 13 Feb 2020 08:26:35 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCHv2 iproute2-next 1/7] iproute_lwtunnel: add options
 support for geneve metadata
Message-ID: <20200213082635.0fde6ab8@hermes.lan>
In-Reply-To: <0fd1ae76c7689ab4fbd7c9f9fb85adf063154bdb.1581594682.git.lucien.xin@gmail.com>
References: <cover.1581594682.git.lucien.xin@gmail.com>
        <0fd1ae76c7689ab4fbd7c9f9fb85adf063154bdb.1581594682.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Feb 2020 19:56:59 +0800
Xin Long <lucien.xin@gmail.com> wrote:

> +	while (rem) {
> +		parse_rtattr(tb, LWTUNNEL_IP_OPT_GENEVE_MAX, i, rem);
> +		class = rta_getattr_be16(tb[LWTUNNEL_IP_OPT_GENEVE_CLASS]);
> +		type = rta_getattr_u8(tb[LWTUNNEL_IP_OPT_GENEVE_TYPE]);
> +		data_len = RTA_PAYLOAD(tb[LWTUNNEL_IP_OPT_GENEVE_DATA]);
> +		hexstring_n2a(RTA_DATA(tb[LWTUNNEL_IP_OPT_GENEVE_DATA]),
> +			      data_len, data, sizeof(data));
> +		offset += data_len + 20;
> +		rem -= data_len + 20;
> +		i = RTA_DATA(attr) + offset;
> +		slen += sprintf(opt + slen, "%04x:%02x:%s", class, type, data);
> +		if (rem)
> +		

Please implement proper JSON array for these. Not just bunch of strings.
