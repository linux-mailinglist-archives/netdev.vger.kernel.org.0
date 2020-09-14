Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEFB268358
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 06:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgINECY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 00:02:24 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43003 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgINECW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 00:02:22 -0400
Received: by mail-lf1-f65.google.com with SMTP id b12so11831700lfp.9;
        Sun, 13 Sep 2020 21:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lr41KwaorelPEhjVUZef/1DYsFz7q63hpTMDBSPa8Eg=;
        b=Odnp2KDcWS+c1CVbJZgohtGj7Mr0wqO47OlVwydlmtf79qftrYHJvJa2Wdt/S4tDxj
         73dJN3NWc/K1ObeD2DGoW9+agHMIxQeUP2A/WTeE1DXYk4n1DDMyyQC1kiBYXyBiyDDB
         YSMxRuAnbyjCc5sIv7pOgHLHROVn+6HDyEtGV//2kmrLT6vezchswdypso1Lq+jozCDO
         fgCnBVundexWZW7o1QN+iBF0NS+VQdB1waT+hMsmCX3TIoVM+rmJlPt83lVvy+5bqUp0
         DC8VTSujglgaUsDq2ymTxXVtHKK8BJg7XjlR3OAkkTnMaBvWzp2Zzaw8qKROzWrx0oyK
         PDDQ==
X-Gm-Message-State: AOAM531HlMN3qN5J2GHelRt4+77UXoFCcw05gZlLAYYmUIhvbEk3n0Pm
        2N9qaWAsuaR/wDA/EaCimWw=
X-Google-Smtp-Source: ABdhPJyBvkAWslgtwCdeGGUwvReHy4IPO8qF2mUegi/A86SMl0JalxhTITUN9B6iLnwaogHqVAHMPg==
X-Received: by 2002:ac2:419a:: with SMTP id z26mr3543688lfh.523.1600056140499;
        Sun, 13 Sep 2020 21:02:20 -0700 (PDT)
Received: from rocinante ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id l14sm3797487lji.99.2020.09.13.21.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 21:02:19 -0700 (PDT)
Date:   Mon, 14 Sep 2020 06:02:18 +0200
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-net-drivers@solarflare.com
Subject: Re: [PATCH] Convert enum pci_dev_flags to bit fields in struct
 pci_dev
Message-ID: <20200914040218.GA29277@rocinante>
References: <20200914035756.1965406-1-kw@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200914035756.1965406-1-kw@linux.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Bjorn,

Sincere apologies! I forgot to include the "PCI" prefix in the subject.

Would you like me to send the patch again?

Krzysztof
