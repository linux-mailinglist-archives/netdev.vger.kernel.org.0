Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFFC446FB4
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 19:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhKFSIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 14:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbhKFSIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 14:08:42 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E890C061570;
        Sat,  6 Nov 2021 11:06:01 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id p22so4466170vke.7;
        Sat, 06 Nov 2021 11:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=94W7+Sb7x6CoTRrtD0y+Hoj/h+qLqgZc6JTPeAc2yeI=;
        b=cH7epR89brJq+hQXk2IHKu9bmMBFcdbMJIEeORsmYPx13Ha+HLB/kdHZ+ERYW1nwYK
         +FdPD20hjhMCjmJTsGP+ycmgdCjU7IqFfjVvcHRS6walNpp3P68HWWcErwuoPGmi/7xu
         l6Z4f5Oat+9wNmkHJ/FPrOSzMCOZJgRARWc4bz+dk2oCpGWWRX4zS0dOejpwVusYor+u
         oZLxNsnyoQZ3HhshnOJwOLWUI2YPj8YZpBRpVJhPRn+KG6+aLAluqD2z1W3f4Y5sE6Zu
         K6lCyOhlnmI245OgVNZMeS61yCDBofkaD0pr3RAiVlzx5t+XOkz7X5VNiDJAWk+yCCLI
         jEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=94W7+Sb7x6CoTRrtD0y+Hoj/h+qLqgZc6JTPeAc2yeI=;
        b=l2kAiruFFk1jSWzaMAs8m73g2Dj1HmRiQ+1yO78RMJAtWaYIULkeX7FGuDKi8jGjTV
         f/QDWRC3CHRS3nN0pq1U2NQr7p+lzvFcOwMmB6IvRoihV+HSVyUHxviVvKC58KuvpMDA
         Vdq2YItOdvmQOZjRv0hWVtY5/Hrl6zOaup1Id9Ax9+PbBcV3oKgoTo1aw08SrRjI1ReG
         YjY9o/n47NlAxZxTbQWCQwFlbY73g3spVVaoumbLHkxxkRPlQAUZJdfbBK/VKo5pTty5
         AqJe5pu/Wo/VBwpPOtn7okGvUHHCQhjgockwj2KaW6ejky6CeK0ELzXbTP5/hemXLtth
         PG7Q==
X-Gm-Message-State: AOAM532LSO9do4hb5RNAZQEcUo/lLXX143h739Xl8DvxITuBAmImlVKj
        XRXxincIZ3mXc5Tny678VsLcowVeS7VO9cQlGSE=
X-Google-Smtp-Source: ABdhPJwdRjdtmfCRtUhyRl+XI2gxEd5/J9LiTRHDrVeGlR/sCiba7xd3MA87gpMp7GbeYVZjOtXRiZj/umYp7K7Ik+o=
X-Received: by 2002:a05:6122:2214:: with SMTP id bb20mr82376183vkb.9.1636221960312;
 Sat, 06 Nov 2021 11:06:00 -0700 (PDT)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com> <20211101035635.26999-6-ricardo.martinez@linux.intel.com>
In-Reply-To: <20211101035635.26999-6-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 6 Nov 2021 21:07:03 +0300
Message-ID: <CAHNKnsTZhtmt6DNsEb+EvnFBo9mNPd4pPG=qjvkxyD3pH+KqrA@mail.gmail.com>
Subject: Re: [PATCH v2 05/14] net: wwan: t7xx: Add control port
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Control Port implements driver control messages such as modem-host
> handshaking, controls port enumeration, and handles exception messages.
>
> The handshaking process between the driver and the modem happens during
> the init sequence. The process involves the exchange of a list of
> supported runtime features to make sure that modem and host are ready
> to provide proper feature lists including port enumeration. Further
> features can be enabled and controlled in this handshaking process.

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
> ...
> +struct feature_query {
> +       u32 head_pattern;

Looks like this field should be __le32 since it is sent to modem as is.

> +       u8 feature_set[FEATURE_COUNT];
> +       u32 tail_pattern;

Ditto.

> +};
> +
> +static void prepare_host_rt_data_query(struct core_sys_info *core)
> +{
> ...
> +       ft_query->head_pattern = MD_FEATURE_QUERY_ID;

This should be a

  ft_query->head_pattern = cpu_to_le32(MD_FEATURE_QUERY_ID);

to run on the big-endians CPU. strace will notify you about each
endians mismatch as soon as you change head_pattern field type to
__le32.

> +       memcpy(ft_query->feature_set, core->feature_set, FEATURE_COUNT);
> +       ft_query->tail_pattern = MD_FEATURE_QUERY_ID;

Ditto.

> +       /* send HS1 message to device */
> +       port_proxy_send_skb(core->ctl_port, skb, 0);
> +}

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c b/drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c
> ...
> +static void fsm_ee_message_handler(struct sk_buff *skb)
> +{
> ...
> +       ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
> ...
> +       switch (ctrl_msg_h->ctrl_msg_id) {

This should be:

        switch (le32_to_cpu(ctrl_msg_h->ctrl_msg_id)) {

> +       case CTL_ID_MD_EX:
> +               if (ctrl_msg_h->reserved != MD_EX_CHK_ID) {

Why is this field called 'reserved', but used to perform message validation?

> ...
> +static void control_msg_handler(struct t7xx_port *port, struct sk_buff *skb)
> +{
> +       struct ctrl_msg_header *ctrl_msg_h;
> ...
> +       ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
> ..
> +       switch (ctrl_msg_h->ctrl_msg_id) {

This should be something like this:

        switch (le32_to_cpu(ctrl_msg_h->ctrl_msg_id)) {

--
Sergey
