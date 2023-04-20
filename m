Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A7A6E986E
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjDTPgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDTPgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:36:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F4F1736
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:36:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B7CF649F8
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 15:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C632CC433D2;
        Thu, 20 Apr 2023 15:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682004995;
        bh=zXP06cudN7COnhGA+6me5V2kDnx1YKJ3zeBktKBXEGE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cgHnNzmemzNQWo69iDRZ/r2sExOVjSG4u/juGLwRLpfL+35smBPpX1ku+saxXK5P+
         CiEuMmo9hDdbUZFNK043jonplP6PbScjLuC+HvqjLe2X572/mrSUMgZyV5dOwPeZOF
         dFXNjT+HfLNXM9mfmMPkS6hDjTrN/4G7mNU5inMRmUmB6u1+VjWUi4OWFGWoZWLs0A
         nfIKckiZZ2ZtN22G068eioS1lEsU4sRm0Tpjg0orQN+fjw/eS0rmBArZRyIhT3I4Db
         SqVl4haDLDg9SO3Di67rQCTMAnd0kkgotT1K7bi+Q2jitKgesRKiP8zb9YHZFnO8fe
         nU/deAS/VxHUA==
Date:   Thu, 20 Apr 2023 08:36:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com,
        linyunsheng@huawei.com
Subject: Re: [PATCH net-next v3 2/5] net: wangxun: libwx add rx offload
 functions
Message-ID: <20230420083633.7887f794@kernel.org>
In-Reply-To: <20230420103742.43168-3-mengyuanlou@net-swift.com>
References: <20230420103742.43168-1-mengyuanlou@net-swift.com>
        <20230420103742.43168-3-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 18:37:39 +0800 Mengyuan Lou wrote:
> +/**
> + * Packet Type decoding
> + **/

Please don't use /** for non-kdoc comments.
./scripts/kernel-doc will complain.
Please wait for other reviews before reposting.
-- 
pw-bot: cr
