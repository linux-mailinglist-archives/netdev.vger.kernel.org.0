Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078E7482658
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 03:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiAACkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 21:40:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiAACkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 21:40:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CA8C061574;
        Fri, 31 Dec 2021 18:40:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C55FCB81D57;
        Sat,  1 Jan 2022 02:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33640C36AEC;
        Sat,  1 Jan 2022 02:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641004803;
        bh=YLdiW9lOwymYUrFlUVQ0+nJdGdMK4B3/6Vhsovj0eF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iJVMQzcrtrdwOP8SBFa6cPXnU1K9hTBLfDKYPMF7pqJ9ZnDjH43J81c74TIn6f2e9
         tB7ptWKluLo507vjM6bnl6nFAzCtz0By/qxn7/QRZnz/iEmpQaAniKpV8OhS7nbjOv
         uV4zZAel87t+SNAV5Zj+OI1h3fmpRneRXsJzubA4Jnf1E0fAhTfuempCzHsHhy+GFQ
         j/dMvgmzF+3OrcsaMnEZKK7er+xL/EwQ4VdJr6BJGMrJAoBbyLbhF39r5951/z5A3s
         4NMtsFNiiL1MyesWy8reCHnqwTLQ6MD/YsoKTfuuZHuC5vf2W9VnT7O4DyK99VXhxF
         xNlfaqAgZhJLQ==
Date:   Fri, 31 Dec 2021 18:40:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2021-12-31
Message-ID: <20211231184002.4fbe18b3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211231160050.16105-1-daniel@iogearbox.net>
References: <20211231160050.16105-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Dec 2021 17:00:50 +0100 Daniel Borkmann wrote:
> First of all, we wish you both a happy new year! :-)

Happy new year! :)
