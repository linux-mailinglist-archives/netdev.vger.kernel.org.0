Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB05F62E220
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 17:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239885AbiKQQjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 11:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240672AbiKQQiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 11:38:55 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF795BD4F;
        Thu, 17 Nov 2022 08:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=szX2DX0NFuU0Ctkur/cJDq4SkrlLk8MpXL6ulWpPXM8=; b=G/ZAJYqPO61iLpXimXwEzKu2yC
        DDJkjkdQeZDzJcfGKHGTIMtQt2HBP1j6PTmlvZSdGbRKtA7VmX0cUEmmVbloTI34rEIyE8lBJMtIs
        qSHSMknR/N7AjvMm//Fn6hSz/MorN61PXnFW/fZmWFDRLqABJGmGasYEpcRW7b0Pcz8MeZrJKncxY
        7PJ4ma3mofoPd316XJ0BekDJNcSZHfJJAmNiZXoaJqon0xKpbuo4vmHMetN3Q9qZYnDyLnClUVXa0
        uuNr6ceZNdeo61tNBSh3naa9sy120hK0bO6uv7KGkdkjTYvhsOooZ65tUHaYDVXZEWFT/tBphiber
        xlx7ydyQ==;
Received: from [2601:1c2:d80:3110::a2e7]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovhuT-00G1Rv-Tw; Thu, 17 Nov 2022 16:38:42 +0000
Message-ID: <8baab0a4-aa71-2fd9-d3cd-93daf1d792cb@infradead.org>
Date:   Thu, 17 Nov 2022 08:38:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: Missing generic netlink controller operations
Content-Language: en-US
To:     Collin <collin@burrougc.net>, linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
References: <40386821-902a-4299-98c8-cbf60dbd4c2c@app.fastmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <40386821-902a-4299-98c8-cbf60dbd4c2c@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[change linux-netdev@ to netdev@]

On 11/16/22 19:54, Collin wrote:
> While messing around with libnl and netlink I noticed that despite existing in an enum in linux/genetlink.h, the CTRL_CMD_{NEW,DEL,GET}OPS operations (and in fact, all operations except for CTRL_CMD_{NEWFAMILY,DELFAMILY,NEWMCAST_GRP,DELMCAST_GRP}) are unimplemented, and have been around, untouched, since the introduction of the generic netlink family. Is there a reason these exist without implementation, or has it simply not been done?

-- 
~Randy
