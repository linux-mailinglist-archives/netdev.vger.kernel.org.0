Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EBC6F49AE
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbjEBSan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 14:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234323AbjEBSal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 14:30:41 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1417D172E;
        Tue,  2 May 2023 11:30:40 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id d75a77b69052e-3ef32014101so42033351cf.3;
        Tue, 02 May 2023 11:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683052239; x=1685644239;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h5KPY5V6nk7zcKsejg06UhQdXAoI4rxf/Iee2Sdzh0s=;
        b=huvapiP1o/a5ROF+RrV3LRzVcl8VvchFqlWxmMyY0NsJlusefbB0XvV8hgh3gac6fo
         fqGq1g63D/En+ZAO6WAdGfLrFNH9C8RkAXnoKz2h9frRYIYjUPjRKoSrewvawZIe/GG/
         ywI+pevRMWLaUqjPPy8faM0HkoJhrfxh3gDXhnwhl8jh99aaADOFeVogqj308IH7+KGj
         1tB3pTQayl8TKnvnR1TsUmh88QYiKArDHl+PDtBEJl5XwAdv5GIkXirh1H64z4cEEal5
         zCd8qPqpJ3raiW4C26zqSdD9DXeozCbVKNWuSNT+FmQiS7tddDCkih+UGCBgft+8QE/b
         Acvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683052239; x=1685644239;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h5KPY5V6nk7zcKsejg06UhQdXAoI4rxf/Iee2Sdzh0s=;
        b=h2te7cM2mUmc2WofklWcEQNEbMJRDTw6GqYVKIAyBh3xNHchLmQZ+LyVOtU29sf1fv
         Al0DAIzfBZc5l+mHxISTZ4XvcNlSVyMaot7LMRpNrVBadbIDosmpdXq88ZddYdofiKDC
         v75o/Rox8VD0fd0zIp9u27RWaJzsws8XdaSHS859tdniBqENyYy/2hcsxnrzfK9pAQXo
         0fy3yYV+jnYtWRD4HBdYRilLNCwAwYe4rX1bidZICW7mnnam6SjnUF8faSiuVS5x4Moi
         nK2Fg3x+Q31LGDK7uLtGzd2HBJ2dX6FXCwkEVGVhP0ml4bcIkwHUhhbtBe5dn7TV42xM
         uWRQ==
X-Gm-Message-State: AC+VfDy8cOxvgFaydqffPOWdELCpm1pYrjPBvN5HI8jtjkyGKwzHhLRM
        yYr5eThYaRzV7w5EIZSHXAc=
X-Google-Smtp-Source: ACHHUZ4cr3QjY4+z+dN7SsjEHvHkOPquQGdAxCy3mXR0QlFgJ/dhUGxFG6VteZXVkN2h21ws6YF9/A==
X-Received: by 2002:ac8:5a8b:0:b0:3ef:327d:ac78 with SMTP id c11-20020ac85a8b000000b003ef327dac78mr25703066qtc.36.1683052239136;
        Tue, 02 May 2023 11:30:39 -0700 (PDT)
Received: from [10.69.71.131] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c136-20020ae9ed8e000000b007468b183a65sm9918474qkg.30.2023.05.02.11.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 11:30:38 -0700 (PDT)
Message-ID: <5e00b4c7-8d3f-e1b2-4359-5ee8fdf92ea9@gmail.com>
Date:   Tue, 2 May 2023 11:30:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net 2/2] net: dsa: mt7530: fix network connectivity with
 multiple CPU ports
Content-Language: en-US
To:     arinc9.unal@gmail.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
Cc:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230501121538.57968-1-arinc.unal@arinc9.com>
 <20230501121538.57968-2-arinc.unal@arinc9.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230501121538.57968-2-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/1/2023 5:15 AM, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> On mt753x_cpu_port_enable() there's code that enables flooding for the CPU
> port only. Since mt753x_cpu_port_enable() runs twice when both CPU ports
> are enabled, port 6 becomes the only port to forward the frames to. But
> port 5 is the active port, so no frames received from the user ports will
> be forwarded to port 5 which breaks network connectivity.
> 
> Every bit of the BC_FFP, UNM_FFP, and UNU_FFP bits represents a port. Fix
> this issue by setting the bit that corresponds to the CPU port without
> overwriting the other bits.
> 
> Clear the bits beforehand only for the MT7531 switch. According to the
> documents MT7621 Giga Switch Programming Guide v0.3 and MT7531 Reference
> Manual for Development Board v1.0, after reset, the BC_FFP, UNM_FFP, and
> UNU_FFP bits are set to 1 for MT7531, 0 for MT7530.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>

This tag is implied by your Signed-off-by tag. No Fixes tag for this one?
-- 
Florian
