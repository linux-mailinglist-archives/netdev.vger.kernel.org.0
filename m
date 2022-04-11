Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099DB4FBA65
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241061AbiDKLEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 07:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346232AbiDKLDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 07:03:04 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F90443FA
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 04:00:48 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1ndrml-00DvDF-Aa; Mon, 11 Apr 2022 13:00:43 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1ndrmf-004g5j-PN;
        Mon, 11 Apr 2022 13:00:37 +0200
Date:   Mon, 11 Apr 2022 13:00:37 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: Wanted: Old network/telecom data sheets + hardware manuals
Message-ID: <YlQKVdw6iS7aKpbo@nataraja>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear netdev, LKML and friends,

as some of you may know, I've recently started to get involved in
"retronetworking" as a hobby, i.e. collecting and running ancient
data communications, telecommunications and computer networking technologies.

We're not just collecting/repairing/operating old hardware and ancient software
stacks (FDDI, TokenRing, ATM, ISDN, ...) but also related hardware documentation,
data sheets, specifications, ...

I would like to call on all Linux network developers to donate any surplus
old networking/telecom chipset documentation, specifications, etc. they may
have.  We have a non-destructive book scanner for sizes up to A2, as well as
a variety of other scanners at our disposal to digitize any paper manuals,
as needed.

More information about this 'call for manuals' can be found at
	https://osmocom.org/projects/retronetworking/wiki/Call_for_old_Manuals

In case anyone is interested, https://osmocom.org/projects/retronetworking/wiki
contains a bit of info on parts of the collected equipment, and we've started
to build a ISDN/TDM/PDH overlay network so people can operate their legacy ISDN
equipment in times where public operators don't offer ISDN service anymore:
https://osmocom.org/projects/octoi/wiki

Some of the documents we already digitized and unearthed include the
German "national ISDN" specs (FTZ 1TR6 etc) at
https://osmocom.org/projects/retronetworking/wiki/German_FTZ_ISDN_Specifications

Thanks in advance for any related document donations.

Kind regards,
	Harald

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
