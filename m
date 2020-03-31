Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9419E198904
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 02:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgCaAts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 20:49:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45078 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbgCaAts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 20:49:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC27A15D057FD;
        Mon, 30 Mar 2020 17:49:46 -0700 (PDT)
Date:   Mon, 30 Mar 2020 17:49:44 -0700 (PDT)
Message-Id: <20200330.174944.1829532392145435132.davem@davemloft.net>
To:     stefano.salsano@uniroma2.it
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        dav.lebrun@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leon@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, bpf@vger.kernel.org,
        paolo.lungaroni@cnit.it, ahmed.abdelsalam@gssi.it
Subject: Re: [net-next] seg6: add support for optional attributes during
 behavior construction
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200331012348.e0b2373bd4a96fecc77686b6@uniroma2.it>
References: <20200319183641.29608-1-andrea.mayer@uniroma2.it>
        <20200325.193016.1654692564933635575.davem@davemloft.net>
        <20200331012348.e0b2373bd4a96fecc77686b6@uniroma2.it>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 17:49:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Salsano <stefano.salsano@uniroma2.it>
Date: Tue, 31 Mar 2020 01:23:48 +0200

> Of course a new application (e.g. iproute2, pyroute) using a new optional
> parameter will not work on older kernels, but simply because the new parameter
> is not supported. It will not work even without our proposed patch.
> 
> On the other hand, we think that the solution in the patch is more backward
> compatible. Without the patch, if we define new attributes, old applications
> (e.g. iproute2 scripts) will not work on newer kernels, while with the optional
> attributes approach proposed in the patch they will work with no issues !

Translation: You want to add backwards compatibility problems because
otherwise you'll have to add backwards compatibility problems.

Sorry, I'm still not convinced.

You must find another way to achieve your objective.
