Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16934E1D16
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 18:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245699AbiCTRV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 13:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245698AbiCTRV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 13:21:28 -0400
X-Greylist: delayed 173 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Mar 2022 10:20:05 PDT
Received: from mail.as201155.net (mail.as201155.net [185.84.6.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798D3E6160
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 10:20:05 -0700 (PDT)
Received: from smtps.newmedia-net.de ([2a05:a1c0:0:de::167]:44818 helo=webmail.newmedia-net.de)
        by mail.as201155.net with esmtps  (TLS1) tls TLS_DHE_RSA_WITH_AES_256_CBC_SHA
        (Exim 4.94.2)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1nVzAs-0002wx-2w; Sun, 20 Mar 2022 18:17:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID; bh=R3xvPyH2LO2SeAjGMqviHKQ0YssFVFGDLalsy+a32Pc=;
        b=kDB5vFIRFcO7i37wsDvKCkiJyqObUP5nPcTw0GVON66/JXSOUrL0ehd80CczxceYFi3y7rSMxitanR3VrD21zhptzBwaxfUHv1L5GuAHAZFEA8UhiRP/2C/WxzICmHQB9hiXnlAq2A/96bMs2T5kz4ZtiNGebiotv6dOy+J++Ag=;
Message-ID: <233074c3-03dc-cf8b-a597-da0fb5d98be0@newmedia-net.de>
Date:   Sun, 20 Mar 2022 18:17:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101
 Thunderbird/99.0
Subject: Re: [PATCH] ath9k: initialize arrays at compile time
To:     John Crispin <john@phrozen.org>, trix@redhat.com, toke@toke.dk,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220320152028.2263518-1-trix@redhat.com>
 <af6042d0-952f-f497-57e7-37fef45a1f76@phrozen.org>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
In-Reply-To: <af6042d0-952f-f497-57e7-37fef45a1f76@phrozen.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Received:  from [81.201.155.134] (helo=[172.21.254.4])
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1nVzAs-0005Nq-NN; Sun, 20 Mar 2022 18:17:02 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 20.03.2022 um 17:48 schrieb John Crispin:
>
>
> On 20.03.22 16:20, trix@redhat.com wrote:
>> array[size] = { 0 };
>
> should this not be array[size] = { }; ?!
>
> If I recall correctly { 0 } will only set the first element of the 
> struct/array to 0 and leave random data in all others elements
>
>     John

You are right, john

Sebastian

