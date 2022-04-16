Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CECB50380B
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbiDPTms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiDPTmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:42:37 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF53033342;
        Sat, 16 Apr 2022 12:40:04 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t12so9538305pll.7;
        Sat, 16 Apr 2022 12:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5Xp410sF+GGnn+k64Aem0Bq20nF9FpJBZpOgxpPYfOM=;
        b=M84mj+tp2XRkS5+g1JBD/J8nfprjEP9Xx2ytgoZNWcMBTTP42X6ZRSpXcO7hFe9/Oo
         02aTUR9pmaftVGumtn+BD0zsgzRHDeeUYHwEZC46IvXiynXEGk8BVJKSu95AVDXsZt/p
         t4JHw/IOVAdlggDWBqPfnE7MIrjLrPcArBrvKK0bI1L4x2vd1vZfodtEunrv9+5jLivM
         RzhLPK+IwE7X9yHdqZHpyQL945co1l+I2H3dg4bprjOYNxzRhsDn2KREvTF9IHC/cj2R
         tr0HjN9UjNAV+ZBbsyTRaWC4SvKM2xUt/7A9G6LwnqiPikL7XXqAcKH2zVuvh1Mt9ONg
         hC9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5Xp410sF+GGnn+k64Aem0Bq20nF9FpJBZpOgxpPYfOM=;
        b=k7ctjhvL4hv/DpSOY9p9YX6kXZ7v993j3568MvNOrjhCY+DZf4ufiCZh73U6CpXZ55
         DmX+PLO1Ij0U9x2ZDV0e7PKQxV1kmNelvsIODGw6A+J6YVySxlKEJsZOK1axW8NqaJjT
         wWLfdvy0tbKvMFkDi9uFu1xOo87oN5g5YlTP/B8DLJJCqty8zu9Oh2azfyV4yLR3NQQn
         /6DerDpVrZbcJbqulCfoTPu5zbcB8IBHp8aZgYpDrmSAI7ka7dC5ri92UeQAfVA9DKF+
         fFZ85dbyuxnnwEDUYYmddmAaSau60CrtjOajXDe4sFHKxBkKcy9bYnDCDnzbZJGLJkgm
         1a3w==
X-Gm-Message-State: AOAM533uDczH6vdbQrk84eT3ThaCY0Yj1yxruf4iDFHVglrDMJB5iv9v
        tjVOu8YnYlpATJpe0SzJivI=
X-Google-Smtp-Source: ABdhPJwnTW8KqhnPwjGmeCpgHceRrEhsRLl5L0AQzXm3+Da3tFcNkHwGjE0Bz7pgd1D+I0xXP4IsAg==
X-Received: by 2002:a17:902:ea0d:b0:158:5910:d683 with SMTP id s13-20020a170902ea0d00b001585910d683mr4720898plg.95.1650138004440;
        Sat, 16 Apr 2022 12:40:04 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a19-20020a17090aa51300b001cde7228b61sm8322237pjq.47.2022.04.16.12.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 12:40:03 -0700 (PDT)
Message-ID: <725e814d-da65-b77d-1a6e-a029d594944f@gmail.com>
Date:   Sat, 16 Apr 2022 12:40:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v4 02/18] net: dsa: sja1105: remove use of
 iterator after list_for_each_entry() loop
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
 <20220415122947.2754662-3-jakobkoschel@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220415122947.2754662-3-jakobkoschel@gmail.com>
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
> The link below explains that there is a desire to syntactically change
> list_for_each_entry() and list_for_each() such that it becomes
> impossible to use the iterator variable outside the scope of the loop.
> 
> Although sja1105_insert_gate_entry() makes legitimate use of the
> iterator pointer when it breaks out, the pattern it uses may become
> illegal, so it needs to change.
> 
> It is deemed acceptable to use a copy of the loop iterator, and
> sja1105_insert_gate_entry() only needs to know the list_head element
> before which the list insertion should be made. So let's profit from the
> occasion and refactor the list iteration to a dedicated function.
> 
> An additional benefit is given by the fact that with the helper function
> in place, we no longer need to special-case the empty list, since it is
> equivalent to not having found any gating entry larger than the
> specified interval in the list. We just need to insert at the tail of
> that list (list_add vs list_add_tail on an empty list does the same
> thing).
> 
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220407102900.3086255-3-jakobkoschel@gmail.com/#24810127
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
