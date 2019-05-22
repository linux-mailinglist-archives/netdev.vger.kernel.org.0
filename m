Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD7B26AB4
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbfEVTSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:18:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60616 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbfEVTSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:18:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F54B14FFA58D;
        Wed, 22 May 2019 12:18:37 -0700 (PDT)
Date:   Wed, 22 May 2019 12:18:36 -0700 (PDT)
Message-Id: <20190522.121836.851176941084038466.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        john.fastabend@gmail.com, vakul.garg@nxp.com, borisp@mellanox.com
Subject: Re: [PATCH net v2 0/3] Documentation: tls: add offload
 documentation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522015714.4077-1-jakub.kicinski@netronome.com>
References: <20190522015714.4077-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 12:18:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 21 May 2019 18:57:11 -0700

> This set adds documentation for TLS offload. It starts
> by making the networking documentation a little easier
> to navigate by hiding driver docs a little deeper.
> It then RSTifys the existing Kernel TLS documentation.
> Last but not least TLS offload documentation is added.
> This should help vendors navigate the TLS offload, and
> help ensure different implementations stay aligned from
> user perspective.
> 
> v2:
>  - address Alexei's and Boris'es commands on patch 3.

Series applied, thanks Jakub.
