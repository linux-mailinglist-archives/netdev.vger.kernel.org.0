Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E4A83976
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfHFTPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:15:15 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46223 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfHFTPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 15:15:15 -0400
Received: by mail-qt1-f194.google.com with SMTP id h21so85679016qtn.13
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 12:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=++I4+PjzOw3sUVV2Nr1rQP557MOgTxJvolxu8QNtWIA=;
        b=McIbQK3o/wBML6eb5Df/pc8sqemFipd6zlVt8a5ZaTyEBr3GoUxsaymQlFIc8/tTjL
         OTxpzXUY5ZJJEQGgmCqBSAJfBfMALhvqUuaXYfMwiACGK31mKmtP5yoGejIgL8R8E7nO
         WWjNWfHXYq0XSY6mTwp8Q+RgeAPL2Z3pkPcDdUiJLRyazVSuyfEN74ugNtz/ye91TUWU
         JMrvIBFa0Pcy81xEyNI7ZjhSZB5dy/NeaSY2QI4wh4SZzB0LLsvBc5tvIXqGKTOBvdWi
         BbfcPAxfhJaplkNBpixe0gDsxpKcPJUeDXpurKNV59mInY8CKgoK4lrjH4VW2PWut7wl
         BniA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=++I4+PjzOw3sUVV2Nr1rQP557MOgTxJvolxu8QNtWIA=;
        b=mJKde3D9c1GeK0anoNs7qJQg7PE9juVyiCx/UZ9qxXuRFkXaTu878kdH4Euhmpjqw/
         XkYWCzZw9tt1WWBKV2eEk+4qCxIJSSMDm6Y0/1z9blRwcsaZPxEEuvU+TGeK7YCQJ9xS
         EYcqR4gje+6AHnyHhF0+QUQUMuuChf1px3QN8jJket3MNofyZHivSmuk8BRJztpDlEW3
         bl3adZ33nPDrL3A49hFDfwCtKKKmhZOpXPErNlN4BiVhY+8AicRkvPPcVbwUOnJKgQyU
         Mq+SPM1UWkkd0TJS7oEhAr7yyOL2MNAU3NWJwWKjcY1bW5aiUOwuYrN5ulxdyh9FYlmj
         Lcqw==
X-Gm-Message-State: APjAAAVUGnt3o/z3aYKPlZwuGojQlZrQVISKEO9mwXhlT1Tc2SJJ6HEs
        Xs+U0cAbHDT7rj0AI0iBywGk0g==
X-Google-Smtp-Source: APXvYqy9jQDPDTR+aOtlSupzdXduQ4ANJLHflDs5X03YXUtE8L3bzK9eKw4oi56xy2JjWXZ9+LphYg==
X-Received: by 2002:ac8:25ac:: with SMTP id e41mr4638980qte.101.1565118914487;
        Tue, 06 Aug 2019 12:15:14 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r189sm39150263qkc.60.2019.08.06.12.15.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 12:15:14 -0700 (PDT)
Date:   Tue, 6 Aug 2019 12:14:49 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Verma <rahulv@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <aelior@marvell.com>, <mkalderon@marvell.com>
Subject: Re: [PATCH net-next v2 1/1] qed: Add new ethtool supported port
 types based on media.
Message-ID: <20190806121449.29cfd6eb@cakuba.netronome.com>
In-Reply-To: <20190806065950.19073-1-rahulv@marvell.com>
References: <20190806065950.19073-1-rahulv@marvell.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Aug 2019 23:59:50 -0700, Rahul Verma wrote:
> Supported ports in ethtool <eth1> are displayed based on media type.
> For media type fibre and twinaxial, port type is "FIBRE". Media type
> Base-T is "TP" and media KR is "Backplane".
> 
> V1->V2:
> Corrected the subject.
> 
> Signed-off-by: Rahul Verma <rahulv@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

LGTM
