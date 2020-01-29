Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DE014C894
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 11:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgA2KNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 05:13:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59030 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgA2KNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 05:13:35 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26A5C15C0123F;
        Wed, 29 Jan 2020 02:13:32 -0800 (PST)
Date:   Wed, 29 Jan 2020 11:13:30 +0100 (CET)
Message-Id: <20200129.111330.440816879769341047.davem@davemloft.net>
To:     andrea.mayer@uniroma2.it
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        dav.lebrun@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        bpf@vger.kernel.org, paolo.lungaroni@cnit.it
Subject: Re: [net-next] seg6: add support for optional attributes during
 behavior construction
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200127190451.11075-1-andrea.mayer@uniroma2.it>
References: <20200127190451.11075-1-andrea.mayer@uniroma2.it>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 02:13:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please resubmit this when the net-next tree opens back up, thank you.
