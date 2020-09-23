Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD6A274DF2
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 02:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgIWAnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 20:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgIWAnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 20:43:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14C1C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 17:43:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3D3413C04A32;
        Tue, 22 Sep 2020 17:26:22 -0700 (PDT)
Date:   Tue, 22 Sep 2020 17:43:09 -0700 (PDT)
Message-Id: <20200922.174309.910890564943407047.davem@davemloft.net>
To:     skardach@marvell.com
Cc:     kuba@kernel.org, sgoutham@marvell.com, netdev@vger.kernel.org,
        kda@semihalf.com
Subject: Re: [PATCH net-next 0/3] octeontx2-af: add support for KPU profile
 customization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921175442.16789-1-skardach@marvell.com>
References: <20200921175442.16789-1-skardach@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 22 Sep 2020 17:26:23 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please create a proper abstraction for uploading configuration information
from a file into a device.

Otherwise every driver will have their own custom weird stuff, unique
module parameter names (module parameters are absolutely rejected for
networking drivers for this reason), etc.  Therefore the user experience
will be awful.

This is non-negotiable.  We are long overdue for such a facility, and
if I were to allow a workaround like this for you, I have to allow it
for everyone else too.

Thank you.
