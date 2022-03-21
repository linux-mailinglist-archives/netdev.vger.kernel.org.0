Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF644E2FD0
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347010AbiCUSWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352061AbiCUSWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:22:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139A95159E
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:21:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9868BB818F0
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 18:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429E1C340E8;
        Mon, 21 Mar 2022 18:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647886861;
        bh=CqQHSkrslC5vvCrHpQ8ZzXcFKFu5fe6arUxxeimPMak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BPKJSkkBUipis2AfIVKjixSRUVKpB1LZ/M03zBg0T5Y/Xw1CBfMDYV0H2yX2foS3l
         mIBtoGu6dYNVStSnPgu9wATERRdg+DTyRberWOp88fWf9O5tbTqin+MwG5bStDdak5
         S620Nj+2EZzo+WnHThy+4c9t7xOMcVSp11qjTuRIE5fwq7lSbIAPUOZbc6RwpeibOR
         4wmH5M8/B+Y+SgYr/cqZ7wrKItuIrtEjHmXg4TRX0n37ip8fTw6jVfXRXy1Qiw3QLE
         GEcpNaaBZ+ja1MaBATN4HSmX0455EZr53Fp6S8xBDpKLNFmxCu5DB7MqXN8FQi1CgD
         uMRjpAa5Tjo1Q==
Date:   Mon, 21 Mar 2022 11:20:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "wangjie (L)" <wangjie125@huawei.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <tanhuazhong@huawei.com>, <salil.mehta@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: Re: [RFC net-next 1/2] net: ethtool: add ethtool ability to set/get
 fresh device features
Message-ID: <20220321112058.4f2de739@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d7fce582-4eb7-9b66-8a19-dd7633154a72@huawei.com>
References: <20220315032108.57228-1-wangjie125@huawei.com>
        <20220315032108.57228-2-wangjie125@huawei.com>
        <20220315121529.45f0a9d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220315195606.ggc3eea6itdiu6y7@lion.mk-sys.cz>
        <20220315184526.3e15e3ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d7fce582-4eb7-9b66-8a19-dd7633154a72@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Mar 2022 14:17:16 +0800 wangjie (L) wrote:
> I think SET_RINGS is OK for tx push, but next new device feature would
> still have this problem. As far as I know, features such as promisc,
> tx push are driver features. So should I still work on the new devfeature
> command netlink version for these standard driver features?

No.
