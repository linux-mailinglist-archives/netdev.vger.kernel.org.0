Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9375037FC
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiDPTkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiDPTkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:40:47 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5EA3056C;
        Sat, 16 Apr 2022 12:38:14 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o5so10107962pjr.0;
        Sat, 16 Apr 2022 12:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mHBrU/6FS1PWEDbIq/XDCf3uhBAcZz4F8hxO2TMTiLI=;
        b=Pbrr9ivXtMgzgh6tAg+nn9bID05dXTfcaIe8ate3Wi8Ohs8t6EglfN2njyWlhjpTul
         tR1mINyTEbBvGPAhMgoSR1rQ4UPnlalDTu2iAw/L/tiSzzl7fdAIr6Ugqvo8ss6hD/dN
         UVJg69EABO+7PeFq4gKg21BZx3XELRHZSWcNQxJ/clehrKZCTOPln+2ntLmYORnGAqk+
         7z1X/i+gqjxIWPnenKvU7Hw4tOY/PXkSz0bb6LGJYDF+8QPHHUPQpAV8pBKDufq+9olJ
         hWtXkC0r0x0GPXCJ/l48JpaMEsFQoEwh0G4j/OD1VJdc562oeWatSqpIcm8HnRfH00Ot
         mY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mHBrU/6FS1PWEDbIq/XDCf3uhBAcZz4F8hxO2TMTiLI=;
        b=UZMjxG4z3xNP5uZAN/92L22L3pOFQPPipF/X1Mo2jP1g0eYtJPqjfiwju+zPFOBFFs
         xGxiUhvjsAiaGjyWM1cVNTqZDKuwh6nVVVOBGoOo6mXAyQKp3ubReXXYFQL6JXhZ6MgW
         VXnzmzAkzScZSagQpYaF3FZYEP8fZNZFWH0sNTpl3wK2oL3DJr8CnzEtZPp2wcP6hRTF
         kTsMIAOoYHeZKvWGnTLv+NbY4pzeldC9aN0EVKfDfJG7cQygJVFcQCY3FKI1/hddWNRg
         ynF2mNn8PC9sCqgOlC2zItiscEHywkW7SnCDnGBmOow66zaF3yPHWj/os+gVOseH2G/U
         SxNQ==
X-Gm-Message-State: AOAM533QFRAXNBrxUYYksRMVdCTSABZGjXONFDPXSyOdav13TtrKJA+3
        zKGy97YJbPIQtHwyOvyp1sI=
X-Google-Smtp-Source: ABdhPJwi0GT93WoZvWRnoJUYJPO0y7rxwdlEN9w4ihHyQC85Vlwb9bQPRJwhzRGybsPLuPs6G04O4Q==
X-Received: by 2002:a17:902:d511:b0:158:3be2:6637 with SMTP id b17-20020a170902d51100b001583be26637mr4462063plg.107.1650137894204;
        Sat, 16 Apr 2022 12:38:14 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q12-20020a056a00084c00b0050a4bae6531sm3749099pfk.165.2022.04.16.12.38.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 12:38:13 -0700 (PDT)
Message-ID: <20e56bff-b456-3301-0594-dac917416a92@gmail.com>
Date:   Sat, 16 Apr 2022 12:38:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v4 05/18] net: dsa: mv88e6xxx: remove redundant
 check in mv88e6xxx_port_vlan()
Content-Language: en-US
To:     Jakob Koschel <jakobkoschel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220415122947.2754662-1-jakobkoschel@gmail.com>
 <20220415122947.2754662-6-jakobkoschel@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220415122947.2754662-6-jakobkoschel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2022 5:29 AM, Jakob Koschel wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> We know that "dev > dst->last_switch" in the "else" block.
> In other words, that "dev - dst->last_switch" is > 0.
> 
> dsa_port_bridge_num_get(dp) can be 0, but the check
> "if (bridge_num + dst->last_switch != dev) continue", rewritten as
> "if (bridge_num != dev - dst->last_switch) continue", aka
> "if (bridge_num != something which cannot be 0) continue",
> makes it redundant to have the extra "if (!bridge_num) continue" logic,
> since a bridge_num of zero would have been skipped anyway.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
