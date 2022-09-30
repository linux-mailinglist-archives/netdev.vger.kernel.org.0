Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAB55F0CF9
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiI3ODH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiI3OCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:02:51 -0400
Received: from mailgw.kylinos.cn (unknown [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4A2156FB6;
        Fri, 30 Sep 2022 07:02:21 -0700 (PDT)
X-UUID: 940e014c3a254d3985eba99eeda13fea-20220930
X-CPASD-INFO: 217f60f7c16c4a78bc7a2cebeb037b7b@e4FxhmNilGePUXivg6SCcoKUa41Ssqe
        chZJeY2OCjLSMbFJkYl1ZgYFqUWJpX2FZVXp4blJdZ2BgZFJ4i3-XblBgXoZgUZB3gXNxhmZelg==
X-CLOUD-ID: 217f60f7c16c4a78bc7a2cebeb037b7b
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,OB:0.0,URL:-5,TVAL:176.
        0,ESV:0.0,ECOM:-5.0,ML:14.0,FD:-5.0,CUTS:-5.0,IP:-2.0,MAL:-5.0,PHF:-5.0,PHC:-
        5.0,SPF:4.0,EDMS:-5,IPLABEL:-2.0,FROMTO:0,AD:0,FFOB:0.0,CFOB:0.0,SPC:0,SIG:-5
        ,AUF:10,DUF:6099,ACD:96,DCD:96,SL:0,EISP:0,AG:0,CFC:-5.0,CFSR:-5.0,UAT:0,RAF:
        0,IMG:-5.0,DFA:0,DTA:0,IBL:-2.0,ADI:-5,SBL:0,REDM:0,REIP:0,ESB:0,ATTNUM:0,EAF
        :0,CID:-5.0,VERSION:2.3.17
X-CPASD-ID: 940e014c3a254d3985eba99eeda13fea-20220930
X-CPASD-BLOCK: 14
X-CPASD-STAGE: 1
X-UUID: 940e014c3a254d3985eba99eeda13fea-20220930
X-User: jianghaoran@kylinos.cn
Received: from [192.168.1.105] [(183.242.54.212)] by mailgw
        (envelope-from <jianghaoran@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1302030813; Fri, 30 Sep 2022 22:03:04 +0800
Subject: test
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20220928065830.1544954-1-jianghaoran@kylinos.cn>
 <20220929191815.51362581@kernel.org>
From:   jianghaoran <jianghaoran@kylinos.cn>
Message-ID: <2c882114-efce-2232-96a6-fa5f8c6c38f3@kylinos.cn>
Date:   Fri, 30 Sep 2022 21:58:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220929191815.51362581@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        RDNS_DYNAMIC,SPF_HELO_NONE,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

