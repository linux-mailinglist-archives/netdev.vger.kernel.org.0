Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EF55330A5
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240430AbiEXSrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbiEXSrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:47:35 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D201167C3;
        Tue, 24 May 2022 11:47:33 -0700 (PDT)
Received: from mail-yb1-f175.google.com ([209.85.219.175]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MxYT3-1ne7Bd0WUL-00xrrT; Tue, 24 May 2022 20:47:32 +0200
Received: by mail-yb1-f175.google.com with SMTP id t26so32432500ybt.3;
        Tue, 24 May 2022 11:47:31 -0700 (PDT)
X-Gm-Message-State: AOAM533a4FVNERu2pjWrwUBw67146AqpBuuunKixdrmDE3lHhXlifrmL
        ebGm/W0LTJPHgUkGTPMI8gA5qLcPpb8SNy8Rg5E=
X-Google-Smtp-Source: ABdhPJz5T8/HGT9q+rhQ52FJuUQIfkAqwGOytT3sEF9l0xACAo++hufwAIOArNDYO3+PBvUXaLQexEx4P88BVZN3spM=
X-Received: by 2002:a25:75c5:0:b0:648:dccd:e1c with SMTP id
 q188-20020a2575c5000000b00648dccd0e1cmr27836533ybc.452.1653418050637; Tue, 24
 May 2022 11:47:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220524155929.826793-1-sashal@kernel.org> <20220524155929.826793-10-sashal@kernel.org>
In-Reply-To: <20220524155929.826793-10-sashal@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 24 May 2022 20:47:13 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3J6gh-0Z8JKEBDva7ox39ps5CCxJ4K7T1LyWMbTHna8Q@mail.gmail.com>
Message-ID: <CAK8P3a3J6gh-0Z8JKEBDva7ox39ps5CCxJ4K7T1LyWMbTHna8Q@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 10/12] net: ftgmac100: Disable hardware
 checksum on AST2600
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        David Wilder <wilder@us.ibm.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, guoheyi@linux.alibaba.com,
        Arnd Bergmann <arnd@arndb.de>, chenhao288@hisilicon.com,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:frba+pIGrmTwdDkZeK/Q9SwwyQ3Uo8/Y9t3IUf0TSSBwM3zZQvf
 aFInhA+sGHT5NuIUW8xuDKMJLEr21J9nkmXcLMBe+9lWizvrBhYbwNKf7eVk58HZf9lRVG2
 ngzjN170rglfYvvJyiwnM8PN5a1SHu54otczFpExY7NzaaTH8kYKRxOF0S1Bnfs84CY/ooX
 gzJA29wLv83hPwFBbpm/w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ddxlAnS7Tbg=:Q8eLzfc9o65XEZEjlBchcf
 1PEUMlImEN7WB/Thxclh6yh2K6NlVZNpLq6u2DN+hU0Vcv2CkHBW/7aJ39ZVESAm9vNH6slTg
 E9+lbwYgpFctPDQ2Z5S75mDfIMPoQwCBx8ETxYuWnsxtm8XIkzhoNKjqBZCipC6xiJld6cmui
 GtAKN6L7lT2CyupEywvkxUfDKaqkcxKX7pZ8ut4a6gTSua+yOjcrsowt5lU4cNIIxzsMJ19f/
 TdRdAoDsGxceRPIhCPw7ive5x2J8mYWqIWMANaaXORZLogQmUoT3GKf0rjk8NNA4WXSRBmLZr
 MNZoHBzjY2Yezru65XZytIVjhkJlDuM3zVjbRgyHiN0LyprZQtoiVCe8O/Wse0l3VBiXNJ5wj
 SmthmUKEPRo3pV7eupaNCslWbtN6/h3O56CG14oW6Tx22H9DGgNNibFiVg10g3ZUoviXZBi7N
 1UWCBo5aOkZCT9YygFKGBNMxWL+dElsfpgni0ErNNt1RNcWnVJRcnJkM1T1NG8/mUz44JadeY
 vTryIZyM2KIfWGPrETsQBlzJOTWb2YaV0qbW4R8Zc3R9KxYmnftVho6BapcETMN6BSHB9oj6m
 ycNA0/uj/AltqcomhGc0OkNsfUrF5cR09Nt3XfGwQkIa3F9+N7Kxc+rXv6/noQtNDVzDxwujP
 sNjfiXGKoPvqldBoYQd0/qY5o8qmUpZ8RDMFVl8kCIWwNr4u3Hoi93w6kVVanto7uaMk8o5U+
 n+jtRMVMLaFJoJwy4kHKKPZ0ktv+/Ia3qs16cL6Nd6XN8r63RqxD7QqRgfNVOc8clCwzwwdBi
 qvUC2jRu3Efh2fGwFKDiertFe5dh5q4cWWunGil/l7KYeeUP6Rxt4+c/WXDo4lR3Byf5bDsuP
 fXWskjJeZqdOI8dmnuug==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 5:59 PM Sasha Levin <sashal@kernel.org> wrote:
>
>  # ip link set mtu 1410 dev eth0
>
> The observed results:
>
>  1500 - good
>  1434 - bad
>  1400 - good
>  1410 - bad
>  1420 - good

Does it require multiples of four? Maybe it just skips the last bytes?

        Arnd
