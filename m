Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9600642C4D0
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 17:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhJMPdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 11:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhJMPdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 11:33:07 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF0FC061570;
        Wed, 13 Oct 2021 08:31:03 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id q13so5316326uaq.2;
        Wed, 13 Oct 2021 08:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/ZBJjm+4NhR4GlguoMXFg/KsmiNX+LHGMnNEPUDTBVw=;
        b=Fz8jsLxny0P6SGfvSlb6H1Z3nW3OOzTlkD0eHH8Vi6PIkZE0ntPUm/egfy5WAyyYXi
         efz4AzuTNAqXDBOJCpsPR3B18LMWPBMf7cJVdFEAjm8DjSfTysfGqEqCqifWecVWuUoy
         oLlVaLIQ2WGBC8AgMKm5g/hX+0WHIjdZ4lz8oIuER9Sb2TZXZPKnMpbDMnNmZHshMQ1L
         d8XkhJs1LheJ+p706OEdhiq62QekVBJAHs88Md1t7a0+kX04udQKSAjrj5DlmZA1L2zY
         0rcnKae5E15Pg+0ubqFnRZoHhg3NsYCG1/4xYG6XzcmEbXGJgd1EzDIQ+6YWoXU3K7Df
         UGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/ZBJjm+4NhR4GlguoMXFg/KsmiNX+LHGMnNEPUDTBVw=;
        b=mBUwBHaEaM+QeGa3I1UZFKS/enPQV3kWt4uBu6he0UiaWuRxuVgdO3zreFtusFOu5J
         Avdike5kmVszmrrjwZWgh8uY4pcQE1Kly2M3Gqdotvx53QEjwcdlyQ7N8+p8yOGx3MiF
         3wLCNJuz5XahHeRT7GF9JBXSkxEPsYuuMdqqcArhQwsUZLfqvVBUkmbjaV5Xi8geNhlm
         F+iHdEeA+xgDUajciGyfKK/JOkLkbyOG1YWUuWkxw35BkQ5ycy16wwA6pYfdgf7xiQrF
         Giv1Le7WRTVvpT/f+gLABS8PsG/LxDdTaZy+Vo6iCtVMn/nc5m0JHX8zhiR3pkTMvS2h
         piaQ==
X-Gm-Message-State: AOAM530//Fe9OsUhpzw6p4NldXe0IvbkWWTyRuRrfFWEbQ1vkrkuR+VP
        k4uywVJJxtkhByUHE/AQodU=
X-Google-Smtp-Source: ABdhPJzaZrAdqtZKw+ljkGjy+/5Eo5FO0rZIfnSJucNiaomXqeBxkKCxVxUzz6zuD6ZH6RjrWsDzjQ==
X-Received: by 2002:a67:ac04:: with SMTP id v4mr39843399vse.50.1634139062835;
        Wed, 13 Oct 2021 08:31:02 -0700 (PDT)
Received: from t14s.localdomain ([177.220.174.164])
        by smtp.gmail.com with ESMTPSA id c10sm6044500vsm.13.2021.10.13.08.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 08:31:02 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id B93B887E7E; Wed, 13 Oct 2021 12:31:00 -0300 (-03)
Date:   Wed, 13 Oct 2021 12:31:00 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] sctp: account stream padding length for reconf chunk
Message-ID: <YWb7tFDwitBYSaXO@t14s.localdomain>
References: <YWPc8Stn3iBBNh80@kroah.com>
 <YWQ43VyG8bF2gvF7@t14s.localdomain>
 <A3FC3A11-C149-4527-84A2-541E951B7A86@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A3FC3A11-C149-4527-84A2-541E951B7A86@nutanix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 12:17:08AM +0000, Eiichi Tsukata wrote:
> Hi Marcelo
> 
> > On Oct 11, 2021, at 22:15, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > 
> > 
> ...
> > 
> > So if stream_num was originally 1, stream_len would be 2, and with
> > padding, 4. Here, nums would be 2 then, and not 1. The padding gets
> > accounted as if it was payload.
> > 
> > IOW, the patch is making the padding part of the parameter data by
> > adding it to the header as well. SCTP padding works by having it in
> > between them, and not inside them.
> > 
> > This other approach avoids this issue by adding the padding only when
> > allocating the packet. It (ab)uses the fact that inreq and outreq are
> > already aligned to 4 bytes. Eiichi, can you please give it a go?
> > 
> > 
> 
> Thanks, I understood. I’ve tested your diff with my reproducer and it certainly works.
> Your diff looks good to me.

Cool, thanks. I'm running a couple more tests on it and will submit it
on your behalf by EOD if all goes well.

Regards,
Marcelo
