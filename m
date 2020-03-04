Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9362178A82
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 07:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgCDGRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 01:17:08 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34373 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgCDGRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 01:17:08 -0500
Received: by mail-qt1-f196.google.com with SMTP id 59so571855qtb.1
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 22:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=caIQwupTESKvTNasK1Y0ElTvzw6QteeHAZwa6qEn9eg=;
        b=LT+4DUqdelw5hwzct80xw781KFz9fUpdWv03qmbfIaRDPf5gCeOi0SlMgy4fcOCrjS
         Z7BMAmBsgGxXB1/PvPH4jXxfXRUEeOiQG/j/glpE9LxVGMlLlmkbBLX712HzhNZrwaws
         foMJ+4eteUXzTuO4PBUVN+2ty+nidAxz7w50g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=caIQwupTESKvTNasK1Y0ElTvzw6QteeHAZwa6qEn9eg=;
        b=WuGpaD3sk5B3jrAxIyg5yjR/g4zF6oKLgKlzR42CxV9TG9UZPQeoFXXM4dPYGDDyym
         ioDjUPwLf2/rZ6r5PGf3i9TZysMRReuB4PgB2VTgw4RWaRrQVTDWOawomNlka4y7k+x/
         bgLZsnlhFa5+ykzBNPuVmHRS3UyYUdIUma2Oe4/PDyrZhk0lOv3mwaMIT1p43ddSF9vv
         z+kse44Nkq6mfzF7bSCAvQhigNr804wBdUT8r2zUBCKmtKbfZIn0AL0TeYAk6rG2BHZw
         dfmo4tT6tdOheptEhUHd2Cml5Se6qcfWCS8dCRwDRFv/VWM+UPl0uoZjnoZ8r1UTEuUl
         CjQA==
X-Gm-Message-State: ANhLgQ1YM71cwqvImKnHkXqLmLNHzQUemdP09cvhmuMe8Omqf0+4h+eq
        Q20K8XoEo6uQrcYS6ur2io2Hl2P1UPhb187y5GTmYQ==
X-Google-Smtp-Source: ADFU+vsvgPcLZ8H45epX3ThPt9B9AcNYov9iQV7Gw0i8/UGVhLzNyCl8C8LPF4L/BgQM6mWn8aY327MvRtdA32kh9NY=
X-Received: by 2002:aed:2331:: with SMTP id h46mr1121896qtc.148.1583302627287;
 Tue, 03 Mar 2020 22:17:07 -0800 (PST)
MIME-Version: 1.0
References: <20200304043354.716290-1-kuba@kernel.org> <20200304043354.716290-10-kuba@kernel.org>
In-Reply-To: <20200304043354.716290-10-kuba@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Tue, 3 Mar 2020 22:16:56 -0800
Message-ID: <CACKFLi=gjgqS5YTqrWSsKD1r7jK=6KvZPqV2ExzdwrXOYUr3GA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 09/12] bnxt: reject unsupported coalescing params
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, mkubecek@suse.cz,
        thomas.lendacky@amd.com, benve@cisco.com, _govind@gmx.com,
        pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 3, 2020 at 8:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Set ethtool_ops->coalesce_types to let the core reject
> unsupported coalescing parameters.
>
> This driver did not previously reject unsupported parameters.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Thanks.
