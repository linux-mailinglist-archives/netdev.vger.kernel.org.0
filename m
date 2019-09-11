Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEA8AF782
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfIKIOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:14:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38740 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfIKIOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:14:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id l11so23395071wrx.5;
        Wed, 11 Sep 2019 01:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AH0YtU6l75+7V9C/xcnLh0BF5eg2S/moPXsD0GowN0I=;
        b=ncy+i7cxqdre3XCv4x7LuFuaklNs156XRzaLAmwJgCloDhwm3CaTjiOK1mMu2GFpOG
         eCDWmSRkFe73j+GnfMxDTBX/VCBzBGHWKiBSx0D5gfw/w3dQ5uAxSUE+ByQsOC8aCwC/
         KAnY6n5pGEkFVcuIDHkAlVTq+eWWgT00LVHA26qE35VR+zRff8a0XGoPJ8wZk4pBVPm0
         /6zjfHJvTqhJNufsIyibIgmgGyNTy1uTTMxrdky2ioRPHvK1eVHg5ggLYr5V/7ozohbs
         Fz4+q8QTiaVrm/21rq8KP7IOK+FoqnQRsOf625SpMmUV09yzCYD3givNndLlzUmaAOpq
         MokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AH0YtU6l75+7V9C/xcnLh0BF5eg2S/moPXsD0GowN0I=;
        b=cAy3Qn06Ph5Rn67PRXnawC912GDf2ZsSXhR07VqxCWIH3lP4WKhN/Tz0gt3Sxdoy9Z
         cIwHuPFuhtvsXegYtjy+ZU04nfSvB2ZHsVFp+B20a2TbJUmS1XOF23BXbab8AFcpaCX2
         E+rpr4SgdrGK3vfJU8vwxESK+i93qFn0ndQ2pKTnuv63vlB7MsfSYnwKhPIV8ibk0Nwt
         XuygLF2PHbCiSNioLbPprvpzapxOj+gyXuNJUc3iVLvs2Drc3482/0vD1gLnh3DaCWHc
         bAmd9GE2Zdp29FO65nCYyemrQN+77g1eMNG9PA3tof5B4xF1pgORxc0pQlbs4kdHeY2b
         StUg==
X-Gm-Message-State: APjAAAUKA2DbTWQNSaZPYai68I2XShBNZUaZmGqvYLqtIeRn8uwfXHYK
        PvNdaU0pQRhDkIPcJ7SEBv+oMnwA9xteInLN2Tk=
X-Google-Smtp-Source: APXvYqy2U4kSNexdXP2g40hCPpi4PfaIq4zpdHunbAlREIOewM+u8/YO6dqcVlgOUHm+ThDgX09rkC34HKlKREBz+qU=
X-Received: by 2002:adf:aa85:: with SMTP id h5mr2609325wrc.329.1568189689549;
 Wed, 11 Sep 2019 01:14:49 -0700 (PDT)
MIME-Version: 1.0
References: <06a808c98b94e92b52276469e0257ef9f58923d0.1568015756.git.lucien.xin@gmail.com>
 <cover.1568015756.git.lucien.xin@gmail.com> <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <20190910.192755.717621354475214603.davem@davemloft.net>
In-Reply-To: <20190910.192755.717621354475214603.davem@davemloft.net>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 11 Sep 2019 16:14:38 +0800
Message-ID: <CADvbK_doDp3oFX5SdSwkqmAf+vkMo9XtqK8hLykixqBZYUL2OQ@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct sctp_paddrthlds
To:     David Miller <davem@davemloft.net>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 1:27 AM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Mon,  9 Sep 2019 15:56:51 +0800
>
> > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > index a15cc28..dfd81e1 100644
> > --- a/include/uapi/linux/sctp.h
> > +++ b/include/uapi/linux/sctp.h
> > @@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
> >       struct sockaddr_storage spt_address;
> >       __u16 spt_pathmaxrxt;
> >       __u16 spt_pathpfthld;
> > +     __u16 spt_pathcpthld;
> >  };
> >
> >  /*
>
> As pointed out you can't add things to this structure without breaking existing
> binaries.
we had the same problem when adding:
spp_ipv6_flowlabel and spp_dscp into struct sctp_paddrparams. in:

commit 0b0dce7a36fb9f1a9dd8245ea82d3a268c6943fe
Author: Xin Long <lucien.xin@gmail.com>
Date:   Mon Jul 2 18:21:13 2018 +0800

    sctp: add spp_ipv6_flowlabel and spp_dscp for sctp_paddrparams

the solution was:

        if (optlen == sizeof(params)) {
                if (copy_from_user(&params, optval, optlen))
                        return -EFAULT;
        } else if (optlen == ALIGN(offsetof(struct sctp_paddrparams,
                                            spp_ipv6_flowlabel), 4)) {
                if (copy_from_user(&params, optval, optlen))
                        return -EFAULT;
                if (params.spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL))
                        return -EINVAL;
        } else {
                return -EINVAL;
        }

I will do the same for this patch. Thanks.
