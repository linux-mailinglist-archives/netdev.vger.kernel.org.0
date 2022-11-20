Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66856314F7
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 16:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiKTPiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 10:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKTPh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 10:37:58 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1739912AD1
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 07:37:55 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2AKFbQi81014056;
        Sun, 20 Nov 2022 16:37:26 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2AKFbQi81014056
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1668958646;
        bh=xYxlmk4kUyiJTSmnwwXN+u0F66w66IH1fhUJ8WZrw7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EEpKPJMXhi/pqZ4I6eHocTC8Zgh6zNjL6uLYGgBY4rZfYu2bK7DA9GAjK9tk9Yr1p
         9uFpJHXqUpt5DjLg6NoEShhuaxpKxMeJAsTqG1onzQRYaurUDgfMvGJFFEgGP74IpZ
         a0xL+lmtJO4aeG9EXpabl9+RNSMvkIkN0LyAkruQ=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2AKFbPLq1014053;
        Sun, 20 Nov 2022 16:37:25 +0100
Date:   Sun, 20 Nov 2022 16:37:25 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next v3] ethtool: add netlink based get rss support
Message-ID: <Y3pJtT2ruV6xZ6if@electric-eye.fr.zoreil.com>
References: <20221116232554.310466-1-sudheer.mogilappagari@intel.com>
 <Y3dgpNASNn6pvT05@electric-eye.fr.zoreil.com>
 <IA1PR11MB6266E62A4F46CCE62C053451E40B9@IA1PR11MB6266.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA1PR11MB6266E62A4F46CCE62C053451E40B9@IA1PR11MB6266.namprd11.prod.outlook.com>
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

Mogilappagari, Sudheer <sudheer.mogilappagari@intel.com> :
[...]
> My observation is there is mix-up of names in current ioctl
> implementation where ethtool_get_rxfh() is called for ETHTOOL_GRSSH
> command. Since this implementation is for ETHTOOL_GRSSH ioctl, we
> are using RSS instead of RXFH as Jakub suggested earlier. Why do you
> think it should be ETHOOL_GRXFH ?

Well... I got confused. :o(

Sorry for the noise.

-- 
Ueimor
