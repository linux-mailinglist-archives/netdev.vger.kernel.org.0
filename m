Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC355BFD0
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbfGAP3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:29:17 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43115 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfGAP3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:29:16 -0400
Received: by mail-yw1-f67.google.com with SMTP id t2so98952ywe.10
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 08:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FrabS61M7oj1xoaPGcNlbFi0Qc0LkMUOEOqWOdFGVTE=;
        b=AYtDGF3rkGuIk0tbWoY2BPBXuAjgR4L35UoAZhy0ad09Sgu9F/png+6asJzoTFRcxG
         UgFEu+2HcU/7WMlPkauRhhjaCYCUfw6O3qmy3YnvVJ+7a5JgjsOthMNzn8SDRazLgSdL
         fq6bt/bfYYJOoIS53F4iZR4nHw0Rm+g/+xl/6V9UMRjjtrOs0WVlR8do7N3r6O2OzNZD
         nLXYtW6mgB8iY8ErcRIYKButLE+l/BQ5+tvLABfKYfwGpTJG0czDUKWs3SHr+P/LTcUw
         i0dvAi2lsfhYbzuDQK6K5TQymxLo4ekzbDQ14WPoPifADOYFD88jfwFxZLeYCorzgupF
         jjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FrabS61M7oj1xoaPGcNlbFi0Qc0LkMUOEOqWOdFGVTE=;
        b=SCgZkVlSW8lytbrZiW5nqhtjOB72ZY58LvgkToOeHmct5LXZcFzcfLijqm+kGh9vE6
         ElllrLQB19vxuB/XKe9mEliS5DWWmB/nkIEqbsb/N0imIwYPdXX7vFHGrAJ/3YjjCbM2
         CZtkmxxcF88Y+BdhpsEhCwPJ24HoO570Y+M1PU0jt95YH5lqR79fhMVqq3cvxq+T533V
         24ZC3FUenIKMoGzyC6lCL0RfJ7S3gkOREop1ViBxr+zCfsVC3KK/hKlezD7vCPBK2VYx
         hYd3CTdu3FDZHNFQF0dgoqCAeAVA0Ts/Va8mhLN4ml/pMb+7Vlp6KtPE91WMENMxZwqS
         BD6A==
X-Gm-Message-State: APjAAAV8kUoQuKcKXnlzwhkQcC1W/MXs8QFwdSUjClUdf1PxWC0Bb0ew
        qQGOrfIVw4BE5aRVq+KurdRj4OkF
X-Google-Smtp-Source: APXvYqyefJ4OKMKjmF4JoBKOm4GPxXmb2hd6bS5pQOj0ViMPO0JugDaIX6eqJND/t1IrNPt3lX0F+w==
X-Received: by 2002:a81:a18b:: with SMTP id y133mr15182632ywg.239.1561994954859;
        Mon, 01 Jul 2019 08:29:14 -0700 (PDT)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id p123sm1095549ywe.109.2019.07.01.08.29.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 08:29:13 -0700 (PDT)
Received: by mail-yw1-f46.google.com with SMTP id l79so96508ywe.11
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 08:29:13 -0700 (PDT)
X-Received: by 2002:a81:9987:: with SMTP id q129mr14969220ywg.190.1561994953323;
 Mon, 01 Jul 2019 08:29:13 -0700 (PDT)
MIME-Version: 1.0
References: <1561984257-9798-1-git-send-email-john.hurley@netronome.com> <1561984257-9798-4-git-send-email-john.hurley@netronome.com>
In-Reply-To: <1561984257-9798-4-git-send-email-john.hurley@netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Jul 2019 11:28:39 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfOwv_Oj2q5T=0ergA32f1akR0mBiG-qRcr6z0F_FWnVA@mail.gmail.com>
Message-ID: <CA+FuTSfOwv_Oj2q5T=0ergA32f1akR0mBiG-qRcr6z0F_FWnVA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/5] net: core: add MPLS update core helper
 and use in OvS
To:     John Hurley <john.hurley@netronome.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, jiri@mellanox.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>, simon.horman@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 8:31 AM John Hurley <john.hurley@netronome.com> wrote:
>
> Open vSwitch allows the updating of an existing MPLS header on a packet.
> In preparation for supporting similar functionality in TC, move this to a
> common skb helper function.
>
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> ---
>  /**
> + * skb_mpls_update_lse() - modify outermost MPLS header and update csum
> + *
> + * @skb: buffer
> + * @mpls_lse: new MPLS label stack entry to update to
> + *
> + * Expects skb->data at mac header.
> + *
> + * Returns 0 on success, -errno otherwise.
> + */
> +int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse)
> +{
> +       struct mpls_shim_hdr *old_lse = mpls_hdr(skb);
> +       int err;
> +
> +       if (unlikely(!eth_p_mpls(skb->protocol)))
> +               return -EINVAL;
> +
> +       err = skb_ensure_writable(skb, skb->mac_len + MPLS_HLEN);
> +       if (unlikely(err))
> +               return err;
> +
> +       if (skb->ip_summed == CHECKSUM_COMPLETE) {
> +               __be32 diff[] = { ~old_lse->label_stack_entry, mpls_lse };
> +
> +               skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
> +       }
> +
> +       old_lse->label_stack_entry = mpls_lse;

skb_ensure_writable may have reallocated the skb linear. old_lse needs
to be loaded after. Or, safer:

  mpls_hdr(skb)->label_stack_entry = mpls_lse;
