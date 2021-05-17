Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3B0386CA6
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245631AbhEQVxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:53:01 -0400
Received: from blyat.fensystems.co.uk ([54.246.183.96]:60686 "EHLO
        blyat.fensystems.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhEQVxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 17:53:01 -0400
Received: from dolphin.home (unknown [IPv6:2a00:23c6:5495:5e00:72b3:d5ff:feb1:e101])
        by blyat.fensystems.co.uk (Postfix) with ESMTPSA id 4DA8144319;
        Mon, 17 May 2021 21:51:39 +0000 (UTC)
Subject: Re: [PATCH] xen-netback: Check for hotplug-status existence before
 watching
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc:     "paul@xen.org" <paul@xen.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Ian Jackson <iwj@xenproject.org>, Wei Liu <wl@xen.org>,
        Anthony PERARD <anthony.perard@citrix.com>
References: <20210413152512.903750-1-mbrown@fensystems.co.uk>
 <YJl8IC7EbXKpARWL@mail-itl>
 <404130e4-210d-2214-47a8-833c0463d997@fensystems.co.uk>
 <YJmBDpqQ12ZBGf58@mail-itl>
 <21f38a92-c8ae-12a7-f1d8-50810c5eb088@fensystems.co.uk>
 <YJmMvTkp2Y1hlLLm@mail-itl>
 <df9e9a32b0294aee814eeb58d2d71edd@EX13D32EUC003.ant.amazon.com>
 <YJpfORXIgEaWlQ7E@mail-itl> <YJpgNvOmDL9SuRye@mail-itl>
 <9edd6873034f474baafd70b1df693001@EX13D32EUC003.ant.amazon.com>
 <YKLjoALdw4oKSZ04@mail-itl>
From:   Michael Brown <mbrown@fensystems.co.uk>
Message-ID: <ed4057aa-d69e-e803-752b-c007ab4e707d@fensystems.co.uk>
Date:   Mon, 17 May 2021 22:51:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YKLjoALdw4oKSZ04@mail-itl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        blyat.fensystems.co.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/05/2021 22:43, Marek Marczykowski-Górecki wrote:
> In any case, the issue is not calling the hotplug script, responsible
> for configuring newly created vif interface. Not kernel waiting for it.
> So, I think both commits should still be reverted.

Did you also test the ability for a domU to have the netfront driver 
reloaded?  (That should be roughly equivalent to my original test 
scenario comprising the iPXE netfront driver used to boot a kernel that 
then loads the Linux netfront driver.)

Michael


