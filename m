Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B7E655DFA
	for <lists+netdev@lfdr.de>; Sun, 25 Dec 2022 19:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiLYSIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 13:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLYSIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 13:08:04 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6132BC9
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 10:08:02 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2BPI7Voq2010337;
        Sun, 25 Dec 2022 19:07:31 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2BPI7Voq2010337
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1671991651;
        bh=NqHV6OvafQ87tUvwNtZnjbzD4LznJjNhuYfIjvnA1cQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C+RU5xer4r2B35urnAVuXh7PtffPq3bTCT2sC73lhDxp/rcK8IcP3HxKUNkZHfPn8
         fdvi7pydHhFx+18D61Gf5uoOrJ2Qq/9bAUXvncfh0dmf0msn504/7SNF4uM5NFsbl6
         n4NcB6T9MjO0rdMQyLFJmShEV4ydy+Rbk1PY7jPI=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2BPI7S0U2010336;
        Sun, 25 Dec 2022 19:07:28 +0100
Date:   Sun, 25 Dec 2022 19:07:28 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        stephen@networkplumber.org
Subject: Re: [PATCH ethtool-next v2 2/2] netlink: add netlink handler for get
 rss (-x)
Message-ID: <Y6iRYO5+cIo5exxu@electric-eye.fr.zoreil.com>
References: <20221222001343.1220090-1-sudheer.mogilappagari@intel.com>
 <20221222001343.1220090-3-sudheer.mogilappagari@intel.com>
 <20221221172207.30127f4f@kernel.org>
 <IA1PR11MB6266430ED759770807768D4EE4E89@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20221222180219.22b109c5@kernel.org>
 <Y6WMIANorlX8lMfN@electric-eye.fr.zoreil.com>
 <20221223115049.12b985b1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221223115049.12b985b1@kernel.org>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> :
> On Fri, 23 Dec 2022 12:08:16 +0100 Francois Romieu wrote:
[...]
> > 'ip' json output does not use the suggested format.
> > 
> > It may be interesting to know if the experience proved it to be
> > a poor choice.
> 
> Hopefully without sounding impolite let me clarify that it is precisely
> *experience* using the JSON output of ip extensively in Python and Ruby
> (chef) which leads me to make the suggestion.

Thank you for the explanation.

While misguided, I've always worked under the assumption that JSON could
also be looked at (especially when tools take care of indenting it).
Knowing that there is a strict "JSON as an interchange format only" policy
and that apparent lack of consistency may be seen as the legacy of mistaken
choices is an helpful hint.

So, no place for hexadecimal, yes.

-- 
Ueimor
