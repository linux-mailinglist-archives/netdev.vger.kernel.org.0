Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1457A52C397
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 21:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242020AbiERTjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 15:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242011AbiERTjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 15:39:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCF32044F5
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 12:39:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58953B821AB
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 19:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49E5C385A9;
        Wed, 18 May 2022 19:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652902789;
        bh=M9HKV3jcuLU4861TlslqBozyOaXE6j8enLcTeOgiz48=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mUdbb4lb1u5xTfI4BzUjFKRKgkkeKllaMFBfhgTZvv0bhK34+aLIgZPu+yW3OhAtK
         jveHHIkznQtjVYlcPWZm9rPyp+ZSinX9SmqzvnMJL17hAwg2PKtKMRj8bsIMky6XAe
         c2GZMxXygGlxw+UloGqgViE/P57tXQdHsmsM0dTj+46ube8rQDKMlGuSIHiZyuufyq
         eWnqGjT29KcQF1ZH9uvn25MMWplNuuwzUOl3/2RjpGC8h/XfyxYU/L280b7ersJNm5
         ll9kbLa0cgfwNCacsV99vwbdxERRbw9k1sZ9ZxMnmPU81+jezKixtH83f3P4q8U7s6
         Mc4FgiI/mpWhg==
Date:   Wed, 18 May 2022 12:39:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        Jeffrey Ji <jeffreyji@google.com>
Subject: Re: [PATCH net-next] show rx_otherhost_dropped stat in ip link show
Message-ID: <20220518123947.44a23904@kernel.org>
In-Reply-To: <CACB8nPkQkH3fJt29kNQ_YqikP8eKPSuBJvh-_cFO_zqie2rw0A@mail.gmail.com>
References: <20220509191810.2157940-1-jeffreyjilinux@gmail.com>
        <YnoPn+hQt7hQYWkA@shredder>
        <CACB8nPkQkH3fJt29kNQ_YqikP8eKPSuBJvh-_cFO_zqie2rw0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 07:29:08 -1000 Jeffrey Ji wrote:
> I thought we wanted to avoid otherhost_dropped being counted as an
> error, I recall Jakub saying something about not wanting users to call
> for help when they see error in the counter name.

You should probably set up a normal email client if you want to
continue working on the kernel, you replied to the wrong message :S

Yes, displaying the otherhost as an error could be too alarming.
That said the split between the main RX: line and RX errors: in
ip -s -s is somewhat arbitrary so no strong preference here.
