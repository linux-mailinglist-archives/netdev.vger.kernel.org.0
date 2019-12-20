Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0AF7128188
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 18:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfLTRkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 12:40:07 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35476 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfLTRkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 12:40:07 -0500
Received: by mail-io1-f66.google.com with SMTP id v18so10217386iol.2
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 09:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0AqPPZeV340aok3IajiTYV80c9EyeAEtP9zyajA3AhU=;
        b=PBS5knjYER0WwrdMFJOeRBcqQehslKqPRMWCKCqvhnynBTl8ixV6KckFQGPO7NDbVR
         Vp4q9mdm5UR5VoUWyqx+ZuI6dzm+CXczdgGNM79d/BeZYyjvNsfspnvF0weg26ZJ0C6D
         jI8Dx3MEPg/hyWkuVYiP+vRhZkgcq8K1Ymhk8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0AqPPZeV340aok3IajiTYV80c9EyeAEtP9zyajA3AhU=;
        b=PaPw/Bg5kQpSX9uLdc7R6Ju8TLhzLkXdbWYaU6+ssvDGXQndCBvbVfXX/XtxSNWMrr
         PRHmkB7RorSjb0LtJsFFwFuymvNIyrYetbkA8Zb5Y6PC0qOQSYWpNDwjFfCKDRDuE6xC
         ayIzFmapDSqxRtmbrm59pspToBL2a8fRnqEQiy7Kyrxh9S5CMqOw1mGGnotN3Vj9yWlj
         augsooPr6e8A3ksn3oEOFQdzlAA2pTu3p/DfJDWhzN8/zZTWiwS6ILgTPIJJ+XoiJQYH
         7waVBIVP7LNjYOoEWm7EJqX50vAoL8NYdwMGSZ8BOxS4KN86tvbSHR/D0+jAlTQdYgJh
         MjBg==
X-Gm-Message-State: APjAAAUmWrMgCSuIMxiuo1Iop+QEPqf6aEJVF9yX74BvWVDKFVIIu+8d
        PYkRCaWAlr28AASis3hlz6jUDqSbQKMmGcrk5lbU6w==
X-Google-Smtp-Source: APXvYqyk39MfjFaIWnuNn2CTnC9MdSzTPD2ePTU8GVkNLcctEi+AlQcxJC/pvoLrPeX6oOUZgUYP4CpRMSi+QlgiUoc=
X-Received: by 2002:a5d:9eda:: with SMTP id a26mr11157961ioe.238.1576863606674;
 Fri, 20 Dec 2019 09:40:06 -0800 (PST)
MIME-Version: 1.0
References: <1576798379-5061-1-git-send-email-aroulin@cumulusnetworks.com>
 <20191220155023.GA61232@C02YVCJELVCG.dhcp.broadcom.net> <28488.1576859733@famine>
 <20191220171821.GA67500@C02YVCJELVCG.dhcp.broadcom.net>
In-Reply-To: <20191220171821.GA67500@C02YVCJELVCG.dhcp.broadcom.net>
From:   Andy Roulin <aroulin@cumulusnetworks.com>
Date:   Fri, 20 Dec 2019 09:39:54 -0800
Message-ID: <CAJd=RsrQViz_EL6b9WnWN_H2mRnQGd+ex4UF6nRYSMBpXekAiQ@mail.gmail.com>
Subject: Re: [PATCH net-next] bonding: rename AD_STATE_* to BOND_3AD_STATE_*
To:     Andy Gospodarek <andy@greyhouse.net>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>, vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So I'm OK with just a change that adds 'LACP_*' in the place of '*AD_*'
> in include/uapi/linux/if_bonding.h and the needed changes across the
> rest of the kernel to reflect those changes for now and we can pickup
> the rest of the non-uapi changes later.

Sounds good, I will resend the patch.

Andy
