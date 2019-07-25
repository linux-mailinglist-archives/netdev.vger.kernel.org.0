Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBB075921
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfGYUuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:50:20 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:37871 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfGYUuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 16:50:20 -0400
Received: by mail-qt1-f180.google.com with SMTP id y26so50461051qto.4
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 13:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=C5PLjTxpvl/NAPokJFXQHrnzss2NYvWCUZSUJ3OSXLU=;
        b=yymmeOQ0Hv6hbNBbf0+/ZXJMA7DXlc3m5KVqdc8FYGqRp7bfE6W4I6rdd3y/WYiEjh
         Cys47RnSgDWNPr0uUxRcjDnAkKC+RwG4gX6uR4gVLrN4/qMiKJxt0iXBDLntxdqZ4XHF
         efguv6MWi67AM7822v/E3q6jR8O90awuz4IPX/fwrH8PlIbG+DuB9MqkTgL0McxFA7NI
         5X7/GXnvskGgNUG/pyqtaZC7Aq/YRIj6W9Wv1tzidBBSViqkF5sPJ5r0krNvqrvK3dSJ
         emw87R3vg8wVuaxmN8vKMQHl674QnVktBYN7H/3TLXrNIM/52bBYt7VGuJ2vnb85Rix/
         q2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=C5PLjTxpvl/NAPokJFXQHrnzss2NYvWCUZSUJ3OSXLU=;
        b=FUdfgLpBwOv22wDReRUYhlVcx8KQBZnIGbdHgWkk0EG1nbPfqhg/ILYnkr+3W6NfrS
         ncrAKFbHJtqTst6pvE5Mi35R1TvcavQ3XcvKYr2DJor4NGm6SLNjFPaPd2G+uaZo9jKu
         GfXPOpgK/yLQcsPzYsOCasptTQnbibnoG/shOn907sYrVkMiqQWgA1yY1m7dkA0+GD3l
         XRp/0p6vsWRqFzSfwxAZ5s2attPh0o/qXhGKFVEhI1I15hGtGOCF1pMwwLFEPMsTG13W
         0KpL1GsX8SNW1hLjEQM7lWiAhTfIcjwn5jyiYa9mnqAHjzBVCkGr0TzoNq0OltLvvua9
         hK5A==
X-Gm-Message-State: APjAAAWrwPIylX4xsg8pyWPUqSM1QgHpU4rXjdd/KYAkFaVQ2q9TyBp8
        WQ0iaJuH6pygUI59Wzat02IzBg==
X-Google-Smtp-Source: APXvYqyYZ9OJ0eNc60lbDLdG9B35E034N5e/pEw4oeYA/INlilAYtaPvC3xLRFe1nru38JgJsmps0w==
X-Received: by 2002:aed:3987:: with SMTP id m7mr60850692qte.56.1564087819050;
        Thu, 25 Jul 2019 13:50:19 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w9sm21876588qts.25.2019.07.25.13.50.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 13:50:18 -0700 (PDT)
Date:   Thu, 25 Jul 2019 13:50:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 8/9] nfp: tls: rename tls packet counters
Message-ID: <20190725135015.7be864d5@cakuba.netronome.com>
In-Reply-To: <20190725203618.11011-9-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
        <20190725203618.11011-9-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jul 2019 20:36:50 +0000, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> Align to the naming convention in TLS documentation.
> 
> Fixes: 51a5e563298d ("nfp: tls: add basic statistics")
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
