Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F0462F2BE
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 11:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241268AbiKRKjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 05:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241289AbiKRKjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 05:39:10 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3127751C27
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 02:39:07 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2AIAcTXv967143;
        Fri, 18 Nov 2022 11:38:29 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2AIAcTXv967143
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1668767909;
        bh=muQgLjaEPCDL730ZUGWcB3ADVmyU91edzoBR0AycM3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oj0wGHeMdh8ZWOawf0OFVSHPnsSAGzbc34z7HPNJVxj+Yw934JNEBAvB99qKTwdF9
         MqH1VXRQxXYvAxh1Ni8iJJegMeIU88w6x0ABKhh5tfukShPJgQzMd2D0adTE8rWJCH
         gof+wSfoHffTKSiPLH650OCC2UtBG2LYcI9P9AGI=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2AIAcSww967142;
        Fri, 18 Nov 2022 11:38:28 +0100
Date:   Fri, 18 Nov 2022 11:38:28 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mkubecek@suse.cz,
        andrew@lunn.ch, corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v3] ethtool: add netlink based get rss support
Message-ID: <Y3dgpNASNn6pvT05@electric-eye.fr.zoreil.com>
References: <20221116232554.310466-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116232554.310466-1-sudheer.mogilappagari@intel.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sudheer Mogilappagari <sudheer.mogilappagari@intel.com> :
> Add netlink based support for "ethtool -x <dev> [context x]"
> command by implementing ETHTOOL_MSG_RSS_GET netlink message.
> This is equivalent to functionality provided via ETHTOOL_GRSSH
                                                   ^^^^^^^^^^^^^
Nit: s/ETHTOOL_GRSSH/ETHTOOL_GRXFH/

-- 
Ueimor
