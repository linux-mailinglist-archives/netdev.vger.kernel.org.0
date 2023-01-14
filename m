Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28E166AD29
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 18:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjANRyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 12:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjANRyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 12:54:10 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61045BB9D;
        Sat, 14 Jan 2023 09:54:04 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-4d59d518505so158421647b3.1;
        Sat, 14 Jan 2023 09:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p/qEjmbSVeK4V+FYo0ZgOJZ+qnJjH7HszISNsOG1I+Y=;
        b=hRPwXeCSOzf5/AWDL5o634Ice0AeKNvlAajVW5rjxf/3ORBKBeLQHcP3z0BUznrOqu
         VhfQKIZvJDB0xap+kmcikmUEJzrWep7QhapZw4MuYIe/9qEcPjGhhvPevoiC6l+NMaZz
         5zgeXYrMCODmlb9Y+zzioQKms+DSri0Un+g75ijMfAcic51V3eEywIUHhZARLhBi9YdO
         UhYXR5WOiHLcXzv9MCIrkfKqj4MyWSQC5mNdM356ZnAA61vNk9fueGzUgwbzEOoHhVOK
         W+VjuJ+jBtw2nT0/MWIvTWU7i+icN8qkTJMsFLvMPAjiaY2gEbu0SsJBBQCxqF/MY9vJ
         GrtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p/qEjmbSVeK4V+FYo0ZgOJZ+qnJjH7HszISNsOG1I+Y=;
        b=SH3mNXJg1S96YS/JIZ7X2CeR7WsjCWGjPQvEIj0Q9iKAHgIXCZ0kistBZmXpOEFu/R
         wk2mu4JVW4z1orkxXhVFhnSM+WxE0Igp3Vlm3hpXluGHzVKUs3rdTDDKNQkpzHZknbYX
         LU673Xre6EtomqssavBzo4wHiOaZfFHFDrY/EkMzNDjU3Xo7A6dMcYJJMmLdjDgH5c3W
         bZ0UbJdCdLvWhKVRGy01ZGXetsXwp8e5Edp3uujJXCam4NwuoZ8Tn4Kpv0NcCq45ANF9
         yci/ORbQk5GPzOJeVmHhBladwCmDfiHs+OIi0igpm5Y9vjVJ2UrGjM2uN02Hu83fOh9y
         +v9w==
X-Gm-Message-State: AFqh2kovEBK4bLnlqIkJYf0gq7OwJyjw4jH6t2rqofpU8yk0BTrZ82Cj
        fDhO2/gLSiYMk3zmQretglg1k/ul5Ze7n4/vly8=
X-Google-Smtp-Source: AMrXdXvrWebT442HmX6HQ0V8GkTs/c5o2lRVp+euxIMWdst2mvLBZ+0m1Nun6XW8SQGElWNe6SW0cQKfJZMjKkW1mfw=
X-Received: by 2002:a81:1352:0:b0:4dc:4113:f224 with SMTP id
 79-20020a811352000000b004dc4113f224mr1219838ywt.455.1673718843515; Sat, 14
 Jan 2023 09:54:03 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <d19e0bd55ea5477d94567c00735b78d8da6a38cb.1673666803.git.lucien.xin@gmail.com>
 <CAHC9VhRXd+RkHSRLUt=0HFm42xPKGsSdSkxA6EHwipDukZH_mA@mail.gmail.com>
In-Reply-To: <CAHC9VhRXd+RkHSRLUt=0HFm42xPKGsSdSkxA6EHwipDukZH_mA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 14 Jan 2023 12:52:45 -0500
Message-ID: <CADvbK_e_V_scDpHiGw+Qqmarw8huYYES2j8Z36KYkgT2opED3w@mail.gmail.com>
Subject: Re: [PATCH net-next 06/10] cipso_ipv4: use iph_set_totlen in skbuff_setattr
To:     Paul Moore <paul@paul-moore.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 14, 2023 at 10:39 AM Paul Moore <paul@paul-moore.com> wrote:
>
> On Fri, Jan 13, 2023 at 10:31 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > It may process IPv4 TCP GSO packets in cipso_v4_skbuff_setattr(), so
> > the iph->tot_len update should use iph_set_totlen().
> >
> > Note that for these non GSO packets, the new iph tot_len with extra
> > iph option len added may become greater than 65535, the old process
> > will cast it and set iph->tot_len to it, which is a bug. In theory,
> > iph options shouldn't be added for these big packets in here, a fix
> > may be needed here in the future. For now this patch is only to set
> > iph->tot_len to 0 when it happens.
>
> I'm not entirely clear on the paragraph above, but we do need to be
> able to set/modify the IP options in cipso_v4_skbuff_setattr() in
> order to support CIPSO labeling.  I'm open to better and/or
> alternative solutions compared to what we are doing now, but I can't
> support a change that is a bug waiting to bite us.  My apologies if
> I'm interpreting your comments incorrectly and that isn't the case
> here.
setting the IP options may cause the packet size to grow (both iph->tot_len
and skb->len), for example:

before setting it, iph->tot_len=65535,
after setting it, iph->tot_len=65535 + 14 (assume the IP option len is 14)
however, tot_len is 16 bit, and can't be set to "65535 + 14".

Hope the above makes it clearer.

This problem exists with or without this patch. Not sure how it should
be fixed in cipso_v4. I knew tcpmss_tg4() setting TCP options which also
causes the packet size to grow, but it requires no data payload:

        /* There is data after the header so the option can't be added
         * without moving it, and doing so may make the SYN packet
         * itself too large. Accept the packet unmodified instead.
         */
        if (len > tcp_hdrlen)
                return 0;

and then the new iph->tot_len won't exceed 65535.

Not sure if we can skip the big packet, or segment/fragment the big packet
in cipso_v4_skbuff_setattr().

Again, this patch fixes the issue when it's an IPv4 BIG TCP packets, and
it doesn't introduce any new issues or fix any old issues, but only fix
what the IPv4 BIG TCP may introduce.

Thanks.

>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/ipv4/cipso_ipv4.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> > index 6cd3b6c559f0..79ae7204e8ed 100644
> > --- a/net/ipv4/cipso_ipv4.c
> > +++ b/net/ipv4/cipso_ipv4.c
> > @@ -2222,7 +2222,7 @@ int cipso_v4_skbuff_setattr(struct sk_buff *skb,
> >                 memset((char *)(iph + 1) + buf_len, 0, opt_len - buf_len);
> >         if (len_delta != 0) {
> >                 iph->ihl = 5 + (opt_len >> 2);
> > -               iph->tot_len = htons(skb->len);
> > +               iph_set_totlen(iph, skb->len);
> >         }
> >         ip_send_check(iph);
> >
> > --
> > 2.31.1
>
> --
> paul-moore.com
