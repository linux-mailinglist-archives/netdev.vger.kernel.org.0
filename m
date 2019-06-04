Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C74AE34F5C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFDRys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:54:48 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:35997 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfFDRyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:54:47 -0400
Received: by mail-qt1-f170.google.com with SMTP id u12so14859885qth.3
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Dib/sk+gwf3avbzMONOnt3kJPuM+Vn1jIP/pu4+RMTE=;
        b=Ly0AfPQjtqa2+4BedXGKMbeId86xi5Mrcl23tf/eelXsYFhzpNAFgWcGVEBv9OHxuo
         UNgy6Gxkuh0jikb/NXpl53CgFTN0Ks5qgHKml7Gr32IbIjO3QgEBona8afh8DAPC07DB
         Gy000HzuQoXuZtbCzvv0eAD1VJapepnt4uY8lSMksa9ct78R4m0lh/2Af2e+A+5oYxQ/
         bM0Utwq0/8QgzrVAnr7O+lgVki06O4QYzTNckuAeYmYBFz3EuSShFV4SumtXrpPYMKGx
         i8p5DYqT/qn8KedhqBOL4V/a1rmx6OBI/tRok0nWzSKONpMBABTvQeRXQ1wDnNgFLRd6
         Hslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Dib/sk+gwf3avbzMONOnt3kJPuM+Vn1jIP/pu4+RMTE=;
        b=qGnBJalx31FTtiGStHcfbSYzaUqun/2exgRktBLlvwn9krQZBH0azRIcABv8N6PMbr
         19Ski/PdfBjk3B4xUC31sg1LVhLerQJY9+xVcb+8EDkfRIizOewEG9CN0uwjnNpSIh+Z
         icFZGoClA0HGqgn5VVlKBBTHNIqd4PlXpvZqJ06d2MfuWC7rFFxDB41uP9gAVhz4uGI0
         0q9Hr7GLcxF+KeN0c/hZm43qL5JEhEQ3cUH+LyK8jOxeAp9GQbcVSaIaybJLhSZ39KQr
         sB5tzi9fPX3Sa2OtSTgI5c0YUDM6hvJScgzMk0IBJ7SIM7dh8BqKS7YIgr522feNAsIF
         5u1w==
X-Gm-Message-State: APjAAAWLBG/kOK+RMF9jSG7Wb8VACCwCIMPCyns3F12W1/A6Q1MzcpNz
        /nDoH5i6jmsysYvyTuM1nxBxbw==
X-Google-Smtp-Source: APXvYqy6sJ2frkinaXhdK1JnYmujRIOP6oBiWuIBaJ8L3fahI/LxHt9uKe1/AqiMgSSaQ8d0pAimyg==
X-Received: by 2002:ac8:3037:: with SMTP id f52mr29897689qte.364.1559670886747;
        Tue, 04 Jun 2019 10:54:46 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f33sm12552686qtf.64.2019.06.04.10.54.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 10:54:46 -0700 (PDT)
Date:   Tue, 4 Jun 2019 10:54:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, dsahern@gmail.com, saeedm@mellanox.com,
        leon@kernel.org, f.fainelli@gmail.com
Subject: Re: [patch net-next v3 7/8] netdevsim: implement fake flash
 updating with notifications
Message-ID: <20190604105442.36f16e32@cakuba.netronome.com>
In-Reply-To: <20190604134044.2613-8-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
        <20190604134044.2613-8-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Jun 2019 15:40:43 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
