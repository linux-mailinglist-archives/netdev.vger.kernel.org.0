Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEB8654F70
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 12:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbiLWLJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 06:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLWLJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 06:09:01 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A452708
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 03:08:58 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2BNB8Hag1969686;
        Fri, 23 Dec 2022 12:08:17 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2BNB8Hag1969686
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1671793697;
        bh=P2oiMv/41p8CK+sJX1M+k7xUcunHtNNVo8UQJM/usKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EFPFe29lM0pNo7bsTRNBEY36a7RFXEDCPhwQaooondjk7839iZzTKMkWd7saZso8P
         Fk8heSoGwV0IQrR4A1FPoXmv+NOjcSvKowZj1wxVh/ekdvqBvIw8qAHXgNTAtW/KSd
         focIiAymO0M8v9GgGZG5rPOKRxx4bdWntZ55AubI=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2BNB8Gv91969685;
        Fri, 23 Dec 2022 12:08:16 +0100
Date:   Fri, 23 Dec 2022 12:08:16 +0100
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
Message-ID: <Y6WMIANorlX8lMfN@electric-eye.fr.zoreil.com>
References: <20221222001343.1220090-1-sudheer.mogilappagari@intel.com>
 <20221222001343.1220090-3-sudheer.mogilappagari@intel.com>
 <20221221172207.30127f4f@kernel.org>
 <IA1PR11MB6266430ED759770807768D4EE4E89@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20221222180219.22b109c5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222180219.22b109c5@kernel.org>
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

Jakub Kicinski <kuba@kernel.org> :
> On Thu, 22 Dec 2022 22:57:19 +0000 Mogilappagari, Sudheer wrote:
[...]
> > Output in hex bytes like [ be,c3,13,... ] will be better
> > I fell but it needs below changes. Without below changes
> > output looks ["be", "c3", "13"...].  Will send out 
> > v3 (with below changes as additional patch) unless there 
> > is an objection. 
> 
> Hex would be great, but AFAIR JSON does not support hex :(
> Imagine dealing with this in python, or bash. Do you really
> want the values to be strings? They will have to get converted 
> manually to integers. So I think just making them integers is
> best, JSON is for machines not for looking at...

'ip' json output does not use the suggested format.

It may be interesting to know if the experience proved it to be
a poor choice.

-- 
Ueimor
