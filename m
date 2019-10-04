Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE48BCC4D5
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbfJDVcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:32:41 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38697 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728809AbfJDVcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:32:41 -0400
Received: by mail-qt1-f195.google.com with SMTP id j31so10553196qta.5
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 14:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qPRs4qVdUoPEhC8/2L+nCs3A7HNxIwESIJdZAJqiA54=;
        b=jkLqwVtDS/TS06JBYnMtNhCygKgRIvfOs7XOzC5hstCDsMfutbzMPIvGAtFl8PdmIq
         7QBGPS4n/AazHQnRzLnsurQYIoHvk765jj7yLnLB9v+IBDo3ESVqVEpzi7yRnMy4O696
         xE6bYdmDhhdZT5VW03k+c4tAbe51c+TZLWGWySzg9Fugg+LY3XYTw3a382hrFaN1FP05
         LZU38dw7arbZvFdOgqvSy7IiOizb13/M5RY2XXn6U0H4k1t6VmjW4fxaeyp5RDQ8uxx9
         coAMSi3tXB6oQZo4TGgzKK0UEDuDILs+CNMcdBSOI9uYl5mCkCV7h3U1yKinIGMuoBlX
         N0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qPRs4qVdUoPEhC8/2L+nCs3A7HNxIwESIJdZAJqiA54=;
        b=VBrSuF7A07DRI2YZXfRNTZO7+vo9bb/2JS8A8HkuAidFsVuWhz8lRLSoYP9oyfPyw7
         ouiGSY1f0udb8Y80bQTtj13Te3a99CtpOaFRboTblnQu1qZ2vGCLvutY1DqBq3X7HXjK
         6zCq7jneqBpXkF3Uprxsg5HR/Wh3OFIfYvRrJWpKXep7L7Qr9jtD2NCzGOJ7SI97llMO
         kp5fURp4APVPyD4+/z6Rm8i28dY2RV16HQXFDx7V4nOHC+JApxmcMQA+RtTWwHgGivRT
         S4awtSzmM1HZ+1CaRFyz8cqtKoNHN/H4/HDIbEIKJH0NVrxTr7+hlfM7NwFJnRpcZtgP
         dcPA==
X-Gm-Message-State: APjAAAVx8oQeYkkLhTdIO5h+mJuEZtz9hf3LdKX3UtOqePB2MLbWFH06
        8R8bCtNnEfV7HTHdOENUwY8ywA==
X-Google-Smtp-Source: APXvYqx2Kc3HVGYfynA1FavCyE3zBMUQU14Cid8+uZOEtZx+S8/fzi0pOKOKK3AzRA0fj1UeWzoYXw==
X-Received: by 2002:ac8:4447:: with SMTP id m7mr18171347qtn.185.1570224760075;
        Fri, 04 Oct 2019 14:32:40 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x19sm3425768qkf.26.2019.10.04.14.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 14:32:39 -0700 (PDT)
Date:   Fri, 4 Oct 2019 14:32:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
Message-ID: <20191004143236.334e9e05@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191004210934.12813-3-andrew@lunn.ch>
References: <20191004210934.12813-1-andrew@lunn.ch>
        <20191004210934.12813-3-andrew@lunn.ch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Oct 2019 23:09:34 +0200, Andrew Lunn wrote:
> diff --git a/Documentation/networking/devlink-params-mv88e6xxx.txt b/Documentation/networking/devlink-params-mv88e6xxx.txt
> new file mode 100644
> index 000000000000..cc5c1ac87c36
> --- /dev/null
> +++ b/Documentation/networking/devlink-params-mv88e6xxx.txt
> @@ -0,0 +1,6 @@
> +ATU_hash		[DEVICE, DRIVER-SPECIFIC]
> +			Select one of four possible hashing algorithms for
> +			MAC addresses in the Address Translation Unity.
> +			A value of 3 seems to work better than the default of
> +			1 when many MAC addresses have the same OUI.
> +			Configuration mode: runtime

I think it's common practice to specify the type here? Otherwise looks
good to me, thanks for adding it!
