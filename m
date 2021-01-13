Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C9C2F4246
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 04:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbhAMDOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 22:14:32 -0500
Received: from mail-yb1-f171.google.com ([209.85.219.171]:42507 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbhAMDOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 22:14:31 -0500
Received: by mail-yb1-f171.google.com with SMTP id j17so806062ybt.9;
        Tue, 12 Jan 2021 19:14:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gJCGXqxgvDtzW70a1NmpxZvlYDS5w7ZtBVxNtrBP7Do=;
        b=Wer58H5oMqygL9IsGIGZ8A7a67NdZPfYM597ZbIiuGpPpEWAuWnBksgFmg4mAh3bqv
         xG+pUC6eI3gtPeoLLkvoqVEpsLTNT3laEaQcwn2f0sZh9NMLr8vAHOwRjuA1KEzI730r
         AVKFFKK0yN4T1TWQtFRLrCdXeo2cS+cVLe0YSzEnS3mji/hjCMIJCIsZ2xVUNIEdEhO8
         a4hjdgWfipxisBC+yodmEsIS29xhjUJxXNxUErnMp5HPklNK+7u4tBF5MLJMeS3i5N7P
         2Rp8XzTGPzXuPSHCdJYzvpM3FPAz7UINR8mg/nxBfBtYtlcgwFyMqZFwO5sLKmw/kqPU
         aHoA==
X-Gm-Message-State: AOAM530Dsa/dxOEuSF13N/AxV6mPz0XlLujRVI08alhou4AegTiTVUtW
        yYZ0+0meDi4jscaHYB0jduJbbb3vZq3u/48BK4Y=
X-Google-Smtp-Source: ABdhPJx2O4c4kV21/tXH2s07eXSjxGmf0DwpqKq439B5Sb2M9asJQS1h8EAb9TqcvzBy+M3SHjqAZfnWxvysAwDYRsg=
X-Received: by 2002:a25:f30a:: with SMTP id c10mr355430ybs.514.1610507630791;
 Tue, 12 Jan 2021 19:13:50 -0800 (PST)
MIME-Version: 1.0
References: <20210112130538.14912-2-mailhol.vincent@wanadoo.fr> <202101122332.Z7NglWp9-lkp@intel.com>
In-Reply-To: <202101122332.Z7NglWp9-lkp@intel.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 13 Jan 2021 12:13:39 +0900
Message-ID: <CAMZ6RqJNQ8MtLYu6i0Q3POBFYVrnFh3bUjiQC57vv-UqArCLfA@mail.gmail.com>
Subject: Re: [PATCH v10 1/1] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
To:     kernel test robot <lkp@intel.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>, kbuild-all@lists.01.org,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 13 Jan 2021 at 00:29, kernel test robot <lkp@intel.com> wrote:
>
> Hi Vincent,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on linus/master]
> [also build test ERROR on v5.11-rc3 next-20210111]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]

The patch is applied on linux-can-next/testing. All the warnings
are related to the latest drivers/net/can/dev API changes.

I thought that the test robot only checked the
linux-kernel@vger.kernel.org open list and I didn't bother adding
the "--base". So this is my bad, sorry for that.

Because this is a false positive, I will not send a new
version (unless if requested).


Yours sincerely,
Vincent
