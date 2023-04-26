Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1786EF590
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 15:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240627AbjDZNfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 09:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239947AbjDZNfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 09:35:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AE330F3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 06:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ay6WQ93CNPZkwAsidUP9pr6j43gPl8WP8n6eNfGIhMw=; b=r6algxchZoz88T7rbSCA7U14jD
        jmq6e5DiLaHIOZ35u2nM7QHP9UFJh9bAOuzyT4LssXhIzqDffEjP2Zs2O6opnz9SY6FfLo8zk4gj/
        tBWa5nRTzgn9BtNAr1V8S3iYY7e0ibIa09oGIyMlJ7/3I8U9RmA7fzjyYtVqF+tz5tWk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prfJE-00BH8y-WB; Wed, 26 Apr 2023 15:35:49 +0200
Date:   Wed, 26 Apr 2023 15:35:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: dsa: mv88e6xxx: mv88e6321 rsvd2cpu
Message-ID: <5056756b-5371-4e7c-9016-8234352f9033@lunn.ch>
References: <1c798e9d-9a48-0671-b602-613cde9585cc@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c798e9d-9a48-0671-b602-613cde9585cc@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 10:12:28AM +0200, Angelo Dureghello wrote:
> Hi all,
> 
> working on some rstp stuff at userspace level, (kernel stp
> disabled), i have seen bpdu packets was forwarded over bridge
> ports generating chaos and loops. As far as i know, 802.1d asks
> bpdus are not forwarded.
> 
> Finally found a solution, adding mv88e6185_g2_mgmt_rsvd2cpu()
> for mv88e6321.
> Is it a proper solution ? Is there any specific reason why
> rsvd2cpu was not implemented for my 6321 ?
> I can send the patch i am using actually. in case.

Should it be mv88e6185_g2_mgmt_rsvd2cpu() or
mv88e6352_g2_mgmt_rsvd2cpu()? Does the 6321 only support
01:80:c2:00:00:0x or does it have 01:80:c2:00:00:2x as well?

Please do send a patch, and include a Fixes: tag.

       Andrew
