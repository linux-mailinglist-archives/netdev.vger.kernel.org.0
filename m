Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD54AD38B1
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 07:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfJKFbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 01:31:07 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:32983 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfJKFbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 01:31:07 -0400
Received: by mail-ed1-f68.google.com with SMTP id c4so7564022edl.0
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 22:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cQeqwxzjfC1nV3dhmsXak7D1I5oYPk8w1t4IHz7ODBo=;
        b=oQL72alRUIeR2T/X9Mv6r5cNHuaHyqwlLGHPUFVy4jjLT2HB/T24qE5PMMdsSN/O1I
         ukpPAxvTlm6XFHX6SZLdOanwadv9/Wrpk1oKxSXRmY20o2m05prhp4r+Eejo0kpMldcZ
         Lz4h/IPDq5/R1Ps7CqGo/+xI2ANiDNYHwa1qAWNBeExfEgJYfuo7UPuBOlXlkP+Vlkbm
         oOFe9u2dRqFx6ew0cDYhzrG73/n+c+GcoH3deY9VF0E/md3bOvJ2/69jC6M4m4Y/zvzm
         bsYp4ykPwlhFxZWK+hbIq9aB/cFmNP66njNMMcDuOd3x8HFAXS+CApIMI4eIH2m93Ws6
         saPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cQeqwxzjfC1nV3dhmsXak7D1I5oYPk8w1t4IHz7ODBo=;
        b=YXqAPjaHyHGiNWFQbqyhlLG4QDrU5Bl7PyhEvug4//oSzj7aLLEsJnqw52wqZVQsTv
         Za0eFjgutfpUeYTdo7BRrJ6IeNlP60e3XXNMoCTPRaaRbp7xA87XuNStcHn75de564RS
         a6+yXUgQ39A9WqFSNJW3JFKI2TLqsYq7BtnXLgF1f5fILb+K9vf2anxFe/eXXS7DLDGA
         v5vjHi1hc4eaE42dekZEYN6oWz7qGZUwkW83qGXlC/16HufY6KpCP3/k6/uaBMzYlVgI
         pi9bKxONM2i8aK0kziCsJOg0EePJFAgsCqKxgArzIbZ1udmviqJTVH5CDQmXOU3tgL2P
         X7Ig==
X-Gm-Message-State: APjAAAWGunkcYBi+v0a1Or8G+VVeLyGABbJba/WdhqOkdG4i2YVykFG2
        Y8tD9GFEto1+Ul6awLTAS8Q+WA==
X-Google-Smtp-Source: APXvYqw5G0kJSGofTVhQ/2VS6+6EhXK4xGkk1RcTSd86ioDr25w3KLgSU2J2TvdWrdeK/R67XB7YJw==
X-Received: by 2002:a17:907:20c5:: with SMTP id qq5mr11829795ejb.96.1570771865944;
        Thu, 10 Oct 2019 22:31:05 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id qn27sm1017741ejb.84.2019.10.10.22.31.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Oct 2019 22:31:05 -0700 (PDT)
Date:   Fri, 11 Oct 2019 07:31:02 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        William Tu <u9012063@gmail.com>
Subject: Re: [PATCHv2 net-next 2/6] lwtunnel: add LWTUNNEL_IP_OPTS support
 for lwtunnel_ip
Message-ID: <20191011053101.b42vazaowgsn2l6w@netronome.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
 <f73e560fafd61494146ff8f08bebead4b7ac6782.1570547676.git.lucien.xin@gmail.com>
 <20191009075526.fcx5wqmotzq5j5bj@netronome.com>
 <CADvbK_fpJiVOb0LC9YAHmr-_9nZB85w6Rwf0=FXX4ziyJ9B=3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_fpJiVOb0LC9YAHmr-_9nZB85w6Rwf0=FXX4ziyJ9B=3A@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 05:45:14PM +0800, Xin Long wrote:
> On Wed, Oct 9, 2019 at 3:55 PM Simon Horman <simon.horman@netronome.com> wrote:
> >
> > On Tue, Oct 08, 2019 at 11:16:12PM +0800, Xin Long wrote:
> > > This patch is to add LWTUNNEL_IP_OPTS into lwtunnel_ip_t, by which
> > > users will be able to set options for ip_tunnel_info by "ip route
> > > encap" for erspan and vxlan's private metadata. Like one way to go
> > > in iproute is:
> > >
> > >   # ip route add 1.1.1.0/24 encap ip id 1 erspan ver 1 idx 123 \
> > >       dst 10.1.0.2 dev erspan1
> > >   # ip route show
> > >     1.1.1.0/24  encap ip id 1 src 0.0.0.0 dst 10.1.0.2 ttl 0 \
> > >       tos 0 erspan ver 1 idx 123 dev erspan1 scope link
> > >
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >
> > Hi Xin,
> >
> > thanks for your patch.
> >
> > While I have no objection to allowing options to be set, as per the sample
> > ip commands above, I am concerned that the approach you have taken exposes
> > to userspace the internal encoding used by the kernel for these options.
> >
> > This is the same concerned that was raised by others when I posed a patch
> > to allow setting of Geneve options in a similar manner. I think what is
> > called for here, as was the case in the Geneve work, is to expose netlink
> > attributes for each option that may be set and have the kernel form
> > these into the internal format (which appears to also be the wire format).
>
> Understand.
>
> Do you think if it's necessary to support for setting these options
> by ip route command?
>
> or if yes, should we introduce a global lwtun_option_ops_list where
> geneve/vxlan/erspan could register their own option parsing functions?

Hi Xin,

In the case of Geneve the options are (now) exposed via tc cls_flower and
act_tunnel rather than ip route. The approach taken was to create an
ENC_OPTS attribute with a ENC_OPTS_GENEVE sub-attribute which in turn has
sub-attributes that allow options to be described.

The idea behind this design, as I recall, was to allow other options, say
for VXLAN, to be added via a new sub-attribute of ENC_OPTS.  Without
examining the details beyond your patch I think a similar approach would
work well for options supplied via ip route.

...
