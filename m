Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EC129DA79
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390318AbgJ1XXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388156AbgJ1XVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:21:44 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2010C0613CF;
        Wed, 28 Oct 2020 16:21:44 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id c18so805288wme.2;
        Wed, 28 Oct 2020 16:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IFTKNyt6bqnALkRjbZh3PaGE+gNdZmwnLOvwA8w0udo=;
        b=Is8OAdSDbUBGpapP6gU+ECc+UFO8bxEyRVyr+SGzFJNtgijRgomcOI8O7hKH/WCqnI
         Gn4Rko/CgvByT7E1lD6BqZghyskw4NztIynT0Q7Eupe2Rj/W9DsIInbweKEqC+jWH9NG
         VHgFDB+KNlKnX0Q89Tevk0AVqW4rJbT/obreTxyFWKOCvGUsFGI1xmw+FmFWqYaO0S8Q
         2Ca/eVEsrGhIljneUYC8p8WUMaXbJXvU31U91KMKBgbAVESP0+d4KwkZVO+tzrAKo2++
         NrYEK/arMKe6kmqTalsDMpskNRMj2u+17USSWQMr6xuWxo6c2/tqHYPDxv74EzQuA7eo
         sdJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IFTKNyt6bqnALkRjbZh3PaGE+gNdZmwnLOvwA8w0udo=;
        b=YW/vI1w7pzJQq6aYqyuDU5Nw7vZbAqatSNFL5cJEiSzVhHZ7cPOGprOmkk+mGhuFmb
         gl0PHj1xfqU4CC5pGqCBp6sutAC7gdotrV7uy+k89/SOIeean2GkkFgljEY+mdtit2bu
         +u+VhfHlkbiOUV40AjlOs3BFbjskfIbF7/PMLONdOi+EykAGtcyc0rPg+6ZnWlwXYmL5
         QYa1ci2muq6PTBphOv/yPBpG6mnSPIxsjuKEaBEdKeNp5ZmHC1ZBfrAlk4O/sHi22vmj
         k64UfcFQHweEO766fFWycwEyn6Qxbd1Nw+DZ2A+CMPw4cv9m641+7C4QCQ2e1YQfiDcD
         6eOQ==
X-Gm-Message-State: AOAM531ntrjY7wxdknY3vzowcU0OkAnL/TcE0IKE5Nj/0yWuJBHVTD5a
        SCnf+BXJy5AuOpT073DRy9Vgwa29QI0=
X-Google-Smtp-Source: ABdhPJw7xUyzdI7CmYnSIQklZjolAqGtHWtMweqNApcd5oK1NgKUgJOYjgImayhtnTplz5xKq8R+CA==
X-Received: by 2002:a1c:44d4:: with SMTP id r203mr6670734wma.152.1603865586688;
        Tue, 27 Oct 2020 23:13:06 -0700 (PDT)
Received: from ?IPv6:2001:a61:245a:d801:2e74:88ad:ef9:5218? ([2001:a61:245a:d801:2e74:88ad:ef9:5218])
        by smtp.gmail.com with ESMTPSA id z6sm3442160wmi.1.2020.10.27.23.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 23:13:06 -0700 (PDT)
Cc:     mtk.manpages@gmail.com
Subject: Re: [patch] socket.7: document SO_INCOMING_NAPI_ID
To:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org
References: <1603847722-29024-1-git-send-email-sridhar.samudrala@intel.com>
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <b3df59a9-a2c3-20c8-7563-e974e596dd2a@gmail.com>
Date:   Wed, 28 Oct 2020 07:13:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1603847722-29024-1-git-send-email-sridhar.samudrala@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/20 2:15 AM, Sridhar Samudrala wrote:
> Add documentation for SO_INCOMING_NAPI_ID in socket.7 man page.

Hello Sridhar,

Thank you!

Would it be possible for you to resubmit the patch, with a commit
message that says how you obtained or verified the information.
This info is useful for review, but also for understand changes
when people look at the history in the future.

Also, please start new sentences on new lines (so-called
semantic newlines).

Thanks,

Michael

> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> ---
>  man7/socket.7 | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/man7/socket.7 b/man7/socket.7
> index 850d3162f..1f38273e9 100644
> --- a/man7/socket.7
> +++ b/man7/socket.7
> @@ -519,6 +519,18 @@ This provides optimal NUMA behavior and keeps CPU caches hot.
>  .\" SO_REUSEPORT logic, selecting the socket to receive the packet, ignores
>  .\" SO_INCOMING_CPU setting.
>  .TP
> +.BR SO_INCOMING_NAPI_ID " (gettable since Linux 4.12)"
> +.\" getsockopt 6d4339028b350efbf87c61e6d9e113e5373545c9
> +Returns a system level unique ID called NAPI ID that is associated with a RX
> +queue on which the last packet associated with that socket is received.
> +.IP
> +This can be used by an application to split the incoming flows among worker
> +threads based on the RX queue on which the packets associated with the flows
> +are received. It allows each worker thread to be associated with a NIC HW
> +receive queue and service all the connection requests received on that RX
> +queue. This mapping between a app thread and a HW NIC queue streamlines the
> +flow of data from the NIC to the application.
> +.TP
>  .B SO_KEEPALIVE
>  Enable sending of keep-alive messages on connection-oriented sockets.
>  Expects an integer boolean flag.
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
