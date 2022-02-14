Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680A44B4421
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 09:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbiBNIbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 03:31:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbiBNIbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 03:31:48 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49BD25C69
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 00:31:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1644827488; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=gZ2UKUUM0KG3Hs1l6xh4FSSU7CpgdJcmhKiHGwjLkky116JPlJxWVSJGkFm6iczu7N/jh4Xp/4P03ZlGfksTDyhat1IDb3qeO8NcI/G9LepNn7FGY1bYnE1a8rOfvyQZfENFJbiQlrLEAgC5c0X5f6oqeYdC8nKks1ga4OJS85w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1644827488; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=tgCW2dzfMhaUDAhgswnNpa6KYbU0zkZmAJQu/Urz5xs=; 
        b=mn4oRfevuCUAYZk6eOvcEda43MdvO5QHRCA5xXsTO38+3DqpcMlHaimomhM9ElCWMDc3nCWBGCUG7yh18ySbKZTq8/FPisoJQvfHk4btMJZ4fiavAhw6LW5ga/SkBUakzSNThqReKMJh5O/7Vkk6vxK7tooAImF/JSE+0vk1xaQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1644827487;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=tgCW2dzfMhaUDAhgswnNpa6KYbU0zkZmAJQu/Urz5xs=;
        b=NMy4kF2X2UPGmmZptdcy1Q17tbIieQB4tJRkCBmb6n/FIi8Y/z1vL7g8EMvWHGfn
        yHrOyNlXvdP4VapBMN/tGAZcpNk2DZSp0chYB6f1A0KFi2bYhwnUr+/NP3tAldaT4/a
        dmqoGWpydt7R0LnN3is3cOGI2IqeIuIc9gDAfWGk=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1644827486489890.2772882192239; Mon, 14 Feb 2022 00:31:26 -0800 (PST)
Message-ID: <70f8af2b-6e72-7400-8f2e-71559b595dc7@arinc9.com>
Date:   Mon, 14 Feb 2022 11:31:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] net: dsa: realtek: rename macro to match
 filename
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk
References: <20220212022533.2416-1-luizluca@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220212022533.2416-1-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/02/2022 05:25, Luiz Angelo Daros de Luca wrote:
> The macro was missed while renaming realtek-smi.h to realtek.h.
> 
> Fixes: f5f119077b1c (net: dsa: realtek: rename realtek_smi to)
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Arınç
