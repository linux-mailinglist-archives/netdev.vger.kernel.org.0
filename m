Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA00A597EFA
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 09:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243444AbiHRHJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 03:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243225AbiHRHJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 03:09:08 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF854868B8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 00:09:06 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id w19so1592256ejc.7
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 00:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=uB1dny6tZXinATmuz0fIf4H2QaK3MjZ8vYEWovRHfu4=;
        b=8WejKLL+aMqLWC0O3FQnTQmsIGmJCsnGHI2BDlBU8o4VWw/LcfeBgWzHmX3qQ0kNdP
         i2wsCNg8dEG2PeAx3BljZBM7q9E11q3FuTEevJM6v/fsy6yCCds3XLZ0KNJgMEwickhT
         5pX++joOCNvyGmso9a/ojzehd7Cu+02vF5ZdH+w627ZOLQGf12vEwqgwdFkq2GSxyk3o
         qKVx23t5WYxxqDzVDlUxryvOZHIM45E9l9h0uZxMmePvFva3B4rfwF+trq833C+5x8YJ
         SqjNNHj/sd925+/MH11H9yWzWNmxhAGk+W5tp0j6FKddjOmqYwdrEqQ2VLWtuHStlIh3
         ns3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=uB1dny6tZXinATmuz0fIf4H2QaK3MjZ8vYEWovRHfu4=;
        b=LNn9yUdAzQTqtZjqMSd7Ns4ZMG90COoKBjRxiDzcGLynzsenhG9JBy3+sqRqrdHOQJ
         AdmIbFa2iwouH/Vmel4E7t384r3PwjViPUvuZpsBQKuoVL4iFnuA/fz/dBNvnqQbwNiC
         WYEIGuWES1CpVrleYlrJl9vGumCNTvcPqFEHyht9eYIohTSZGySAIaarZf+oUo2a7HhQ
         53sL34zqc5OMbfYMGu6HjcAx0T6FXCZp4xPgEcGxWRcywmMfw2pKtQgS1W/XhWdgXeR7
         vNo6Pk6f9dkpP8YX8kZtG4B3A8wcf1jVBCF30slhDFpV2QrUolm6lS1eiLuArzvKDlDI
         cmKA==
X-Gm-Message-State: ACgBeo3DoIzn646rHgiQlP7eK0LrOI+CJx2cbJJ8sQpG/3wTKsg3Vm1w
        LYX/MxM+isdWDyzJgPMMiuUTUQ==
X-Google-Smtp-Source: AA6agR6L6Nq587p/lJCgXhHMIohS0fuUSvnisu370SwFRdqGr62Y3rWmL+GZ/dHscdaOTusJwrlmKQ==
X-Received: by 2002:a17:906:6a2a:b0:730:a3f1:aee with SMTP id qw42-20020a1709066a2a00b00730a3f10aeemr1105108ejc.387.1660806544983;
        Thu, 18 Aug 2022 00:09:04 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id f28-20020a056402329c00b004418c7d633bsm594454eda.18.2022.08.18.00.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 00:09:04 -0700 (PDT)
Message-ID: <10091e35-491a-c10f-35ec-044357f09e3e@blackwall.org>
Date:   Thu, 18 Aug 2022 10:09:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next] Remove DECnet support from kernel
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Nathan Fontenot <nathan.fontenot@amd.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Suma Hegde <suma.hegde@amd.com>, Chen Yu <yu.c.chen@intel.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kees Cook <keescook@chromium.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wang Qing <wangqing@vivo.com>, Yu Zhe <yuzhe@nfschina.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
References: <20220818004357.375695-1-stephen@networkplumber.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220818004357.375695-1-stephen@networkplumber.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/2022 03:43, Stephen Hemminger wrote:
> DECnet is an obsolete network protocol that receives more attention
> from kernel janitors than users. It belongs in computer protocol
> history museum not in Linux kernel.
> 
> It has been "Orphaned" in kernel since 2010. The iproute2 support
> for DECnet was dropped in 5.0 release. The documentation link on
> Sourceforge says it is abandoned there as well.
> 
> Leave the UAPI alone to keep userspace programs compiling.
> This means that there is still an empty neighbour table
> for AF_DECNET.
> 
> The table of /proc/sys/net entries was updated to match
> current directories and reformatted to be alphabetical.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> Acked-by: David Ahern <dsahern@kernel.org>
> ---
> 
> Incorporates feedback from the initial RFC.
> The MPLS neighbour table to family table is left alone.
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>




