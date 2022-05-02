Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C31C5174A6
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343626AbiEBQmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386334AbiEBQly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:41:54 -0400
X-Greylist: delayed 487 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 02 May 2022 09:38:21 PDT
Received: from plutone.assyoma.it (unknown [212.237.56.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE20B1F6
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 09:38:21 -0700 (PDT)
Received: from webmail.assyoma.it (localhost [IPv6:::1])
        by plutone.assyoma.it (Postfix) with ESMTPA id 052FE1026164
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 18:30:11 +0200 (CEST)
MIME-Version: 1.0
Date:   Mon, 02 May 2022 18:30:10 +0200
From:   Gionatan Danti <g.danti@assyoma.it>
To:     netdev@vger.kernel.org
Subject: Force mavtap interfaces up
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <116c870676ecab331ec3c76aaec7bf0f@assyoma.it>
X-Sender: g.danti@assyoma.it
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_50,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear list,
I would like to ask if, and how, it is possible to force a macvtap 
interface up even when the underlying physical device has no link 
(reporting NO-CARRIER).

 From my understanding, I can do that via something as "ip link set 
macvtap0 protodown off". And it works, indeed. However, if the 
underlying physical device is plugged & unplugged again, the macvtap0 
interface goes down with it; to restore it, I need to re-run the above 
"protodown off" command.

Does a method exists to always force one or more macvtap interfaces up, 
regardless the physical link status?

Full disclosure: I am trying to use macvtap rather than plain bridge for 
a KVM host and I stumbled across the behavior described above. If the 
physical interface is disconnected, the guests lose connection with each 
other. With a classical bridge setup, disconnecting the physical 
interface only interrupt communication with outer guest/hosts (but 
internal traffic is preserved).

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
