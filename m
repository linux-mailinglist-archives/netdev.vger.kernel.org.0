Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4386885F6
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjBBSCw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Feb 2023 13:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjBBSCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:02:44 -0500
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238C479F28
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:02:27 -0800 (PST)
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay08.hostedemail.com (Postfix) with ESMTP id C5FC114045C;
        Thu,  2 Feb 2023 18:02:25 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf03.hostedemail.com (Postfix) with ESMTPA id 662BB6000F;
        Thu,  2 Feb 2023 18:02:23 +0000 (UTC)
Message-ID: <378b2fd8ce742cbb1f1d2e958690490b53f5b6da.camel@perches.com>
Subject: Re: netdev/checkpatch issue
From:   Joe Perches <joe@perches.com>
To:     =?UTF-8?Q?=E9=99=B6_=E7=BC=98?= <taoyuan_eddy@hotmail.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "dwaipayanray1@gmail.com" <dwaipayanray1@gmail.com>,
        "lukas.bulwahn@gmail.com" <lukas.bulwahn@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Thu, 02 Feb 2023 10:02:22 -0800
In-Reply-To: <OS3P286MB22950EB574F05C341DEEF554F5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
References: <OS3P286MB22950EB574F05C341DEEF554F5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 662BB6000F
X-Stat-Signature: egkrf3p6ex4q1u3e1f36r9wipegh1jab
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19wVNItGaRl9oxw7buOiHdDFHHlqnrVUAk=
X-HE-Tag: 1675360943-210811
X-HE-Meta: U2FsdGVkX1/IKISMMXzsq0rTZ2BdmabYBffxG2eZ8pNK7S4mz02Iz9jOuSWUhH1lJojKEJwsC8OwBciyiV3i1A==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-02-02 at 13:55 +0000, 陶 缘 wrote:
> Hi, Dear checkpatch experts:
> 
>       I may encountered a false-postive issue on checkpatch function.

I think not.
Perhaps send me as an attachment the specific patch file where
you get this error.

