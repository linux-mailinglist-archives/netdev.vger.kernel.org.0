Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0341311EF7F
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfLNB14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:27:56 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32780 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfLNB14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:27:56 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so611189lfl.0
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ScGB0uaG1N2MTFqjHS89TM7sGKsmj+KybyTlxQc+/kA=;
        b=urN4yCffQ5LSBNl1Z4RFIiOkL8cXsodyn7ff1+7ETynmlW15+okWCxijdAyaukz+TO
         gUdfs3pV9ISDCVljmx0R/i3DGQpeHwB6lMvRZGHcBkjjXGodeeGo991HuSzupHSswROS
         sS3bmtwrvuY/yIQqIKi1nsTc2BTtcnTD9FUfuu6L87zy+XI5oLzdEPkSSTRUj2jRt5cK
         sTRIVLwSZfAsTPyvAifl7PA80V+1eS0kgmmfaBZIzOHj5S4J6CLjaOaid6I8t8kX9US+
         MDKiaJ9+9Q7Zpcb2gcyR++s9kvrSn0qyJwtaSpX29QzCX/skTVwfoDYDvveA6Dh+iTlk
         +bRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ScGB0uaG1N2MTFqjHS89TM7sGKsmj+KybyTlxQc+/kA=;
        b=pYN3lTabqag/TxbV9HNudv2BM+1i7eCFmKcFifBL8jAGy4MCea8HEb3fyJ374sJhxL
         0DgxDsPMXd/1FwpBmPEcwb1PujlJaulZ48drh3AEQ9scK0mwqp+vCjKqQVZlp/X/3LGr
         SM7tZvWLeLPFsiAynZ273Tat9jZZnDxAck1vKb8CX0Utr8VqLMjpKYRi9pn0ru2krqhx
         yU9SOVhrCofwx5A8nGQ5APWrYoFZGEGcX+uUKF7b5smPjNoa28rZJtMtIIAsb6XP5KMW
         p86wMT1UxE9z1K+LkODoRGgMVWa3jDQ5lDhDtbpqhKpzi4NnmTtPYtIlkAZXGOJ/fA44
         r8xQ==
X-Gm-Message-State: APjAAAX21nBWaiZY80iniwZCOKeIDbtpR6ISQf8UE7yPSIM/NZkS8gXY
        hDJFgttNOmIl7oDm8ZFDL8yemKYf48g=
X-Google-Smtp-Source: APXvYqw7i7YpZIaz4MAOWDRHBsmcdAJkes1rruFV67i8zLlUBMNNDl+QBJYn9uaGrpWJqtY7TYFyMg==
X-Received: by 2002:a19:c648:: with SMTP id w69mr10408468lff.44.1576286874277;
        Fri, 13 Dec 2019 17:27:54 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v2sm5669883ljv.70.2019.12.13.17.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 17:27:54 -0800 (PST)
Date:   Fri, 13 Dec 2019 17:27:47 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
        julietk@linux.vnet.ibm.com
Subject: Re: [PATCH net v2] net/ibmvnic: Fix typo in retry check
Message-ID: <20191213172747.5e5310c9@cakuba.netronome.com>
In-Reply-To: <1576078719-9604-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1576078719-9604-1-git-send-email-tlfalcon@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 09:38:39 -0600, Thomas Falcon wrote:
> This conditional is missing a bang, with the intent
> being to break when the retry count reaches zero.
> 
> Fixes: 476d96ca9c ("ibmvnic: Bound waits for device queries")
> Suggested-by: Juliet Kim <julietk@linux.vnet.ibm.com>
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Ah damn, looks like this originates from my pseudo code.

I had to fix the fixes tag:

Commit: 847496ccfa22 ("net/ibmvnic: Fix typo in retry check")
	Fixes tag: Fixes: 476d96ca9c ("ibmvnic: Bound waits for device queries")
	Has these problem(s):
		- SHA1 should be at least 12 digits long
		  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
		  or later) just making sure it is not set (or set to "auto").

Applied to net, thanks!

> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index efb0f10..2d84523 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -184,7 +184,7 @@ static int ibmvnic_wait_for_completion(struct ibmvnic_adapter *adapter,
>  			netdev_err(netdev, "Device down!\n");
>  			return -ENODEV;
>  		}
> -		if (retry--)
> +		if (!retry--)
>  			break;
>  		if (wait_for_completion_timeout(comp_done, div_timeout))
>  			return 0;

