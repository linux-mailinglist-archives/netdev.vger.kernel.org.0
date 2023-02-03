Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3536890DC
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjBCH3j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Feb 2023 02:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjBCH3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:29:39 -0500
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A6066026
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 23:29:38 -0800 (PST)
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EAA540223;
        Fri,  3 Feb 2023 07:29:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id DB1AC20013;
        Fri,  3 Feb 2023 07:29:34 +0000 (UTC)
Message-ID: <db14b18de650f0f9c2a207af1432748d853a75e0.camel@perches.com>
Subject: Re: =?UTF-8?Q?=E5=9B=9E=E5=A4=8D=3A?= netdev/checkpatch issue
From:   Joe Perches <joe@perches.com>
To:     =?UTF-8?Q?=E9=99=B6_=E7=BC=98?= <taoyuan_eddy@hotmail.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "dwaipayanray1@gmail.com" <dwaipayanray1@gmail.com>,
        "lukas.bulwahn@gmail.com" <lukas.bulwahn@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Thu, 02 Feb 2023 23:29:33 -0800
In-Reply-To: <OS3P286MB22958BF0734E62B7661D06E0F5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
References: <OS3P286MB22950EB574F05C341DEEF554F5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
         <378b2fd8ce742cbb1f1d2e958690490b53f5b6da.camel@perches.com>
         <OS3P286MB22958BF0734E62B7661D06E0F5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: DB1AC20013
X-Stat-Signature: t1buzhz7eim6zrb5fo7mc73ygjqbcuij
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+KtBKABkD0gqjReAEAvwg8XTEWiK9hLEo=
X-HE-Tag: 1675409374-776795
X-HE-Meta: U2FsdGVkX1/r5c5hUmB+Sa3q3aK40pIeUTmpTI4+tELyotlTaP4JD8KhKCC3kEKv1+xQSX1OzLoE3a5vE87E4A==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-02-02 at 23:42 +0000, 陶 缘 wrote:
> Hi, Joe:
>       Thanks a lot for your time.
>       I put it in the attachment, in case you prefer plain text content in email, i also append it at the end
> by the way, could you let me know if the 'netdev/checkpatch' is calling ./scripts/checkpatch.pl

As I have no idea what netdev/checkpatch is, i have no idea.

The checkpatch script in the kernel does not produce an error
for this input.
