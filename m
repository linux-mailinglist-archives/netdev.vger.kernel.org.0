Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F8D503480
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 08:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiDPGlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 02:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiDPGlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 02:41:55 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E90100E16
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 23:39:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1650091148; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=VjG8/QtTVmOmZvRl2Gl7xyLanYbXVwZ33MH3IIVgstDEeEfRAVmjTVZJ1yLPi8QYnRPjyeKNO0vOXcC1YDEMowWdo4bsrR5mqDR0Vvq/iEMTkd/qn4o2lL9SCLyTicEaAI5XJv9rIaEHoZ0ANDV8IntVFMxZez82MogdWiEPoJo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1650091148; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=IT0sSFhEplyIaeKs9Na8MCumOdpRDb1FwNl66TqyNaw=; 
        b=aaVEt9qebl8lFQnTwuEZ5sqfi2EiG4nDou7nVoDfobtlecw7G4d2iaW2DZH+IZovXRPvDkRLMuiLRD0ugjsGdpumNpvlDFzvXS27aehjeh57qDw3v41VN8HyPcCvkXs04DiGObbdm22jF/Cq03OmGjgoLH4jjXfVfdszTwc16+8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1650091148;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=IT0sSFhEplyIaeKs9Na8MCumOdpRDb1FwNl66TqyNaw=;
        b=NQ8B/VDqF9+naPwEiO/H0Q1V/tpYO1bxv8o5dP2BcPdcjFXreJ2eqxed9pQ6NJ7O
        j3uNRMSUqx/h/4kDe8b11z9AvvQClYhKlaoKZNNQfHJj/f7K0T10SwR4lTXtJ2vYi89
        NP5oTF7YODxmyt6GPmftkepAqkpDR/XLFWh/8aN0=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1650091146352648.4518782847122; Fri, 15 Apr 2022 23:39:06 -0700 (PDT)
Message-ID: <8a0af01d-026a-1f44-3958-efd933febf95@arinc9.com>
Date:   Sat, 16 Apr 2022 09:38:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net 2/2] net: dsa: realtek: remove realtek,rtl8367s string
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org
References: <20220416062504.19005-1-luizluca@gmail.com>
 <20220416062504.19005-2-luizluca@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220416062504.19005-2-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/04/2022 09:25, Luiz Angelo Daros de Luca wrote:
> There is no need to add new compatible strings for each new supported
> chip version. The compatible string is used only to select the subdriver
> (rtl8365mb.c or rtl8366rb). Once in the subdriver, it will detect the

Might as well call the subdriver rtl8365mb like rtl8366rb since you're 
going to send a v2 anyway.

Arınç
