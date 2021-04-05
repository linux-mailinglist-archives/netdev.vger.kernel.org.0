Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C833541E0
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 13:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbhDELwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 07:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbhDELwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 07:52:16 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0E6C061756;
        Mon,  5 Apr 2021 04:52:10 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 91-20020a9d08640000b0290237d9c40382so11068980oty.12;
        Mon, 05 Apr 2021 04:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DaSh0K7X0mQ6+BO0Xt5HMBiFHrPuBx9pFI/jlOiOr/E=;
        b=Cqa4GPEBgBHz24TbqGlqnXbmKR8QRVIIsVDwFMN0Apcla7q259ZS/jtapOygj+0e9h
         6AZRaWoGjoxASxkCKS5cYx2A27iqSxBT/831197RVz2tDC3puznKA6YWQNfRkDRB4W+B
         6vRlZ8OSx1Uxfdq2I9KsiB1AfnfikYvbKwsr4zMdQ9WIXzH1FOEHKxlg7R4pSkmdIKbZ
         eWQsx1Qh8hfU/WyoQ60xSPEdzmaBZCfC4/C4RezEm8+6FrVT5ib1PCvI4DDZJ2Kbn7aP
         k2qf12g3+QhFeldRiErqW0zFHQTo74nLftAkBFvDtZdtuaQjnoU0bD+RMqdRZ2Nl5f84
         qwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DaSh0K7X0mQ6+BO0Xt5HMBiFHrPuBx9pFI/jlOiOr/E=;
        b=qPHR8PqYo67lebec+ckkeKx466xEMG61UnEdzB33sVc7nXIRMetAbe5bXiQ9sN+ud2
         TZH1HRiXdVaJK0QbVt76HSPICIyGk/vNwlRNHFWEnpJciUQN0VG+ZgigQiPzdIG6eES8
         GQnxELmNyUg+ou78Ll+3eCG6MsyhpzSqwLuOHgyTqmQUCzzHjg4n7knC9ZaFJo+iXuGY
         0odrKh4ZoBx7cKAO7wOlQSJ6wgNXZEmnq/IlV91pKbOUYfo+ef1uPIWoBS2NwmfENhA4
         JbAdXatGjtg9OHpo3lf2T76WLCvF9Z3hmts1skvVN/Af94pB2JcNaGCajwyw+sDMFFEs
         aQPg==
X-Gm-Message-State: AOAM5333GRU437tgyb5FH+rIMjZMn7NBphuhHOkYZ7TJVgH5Bot0r2l8
        wza/v8rqv3VwllYRRvCYDDXm5AWgXOzXk9EQizo=
X-Google-Smtp-Source: ABdhPJzTUrHovqBlEzML+lhhqQsuLLn2nHjW2364Usp46LDHinFvHN9N1DSwfCDbbJPosyYRxnMuW084pnbXT7h3a+Q=
X-Received: by 2002:a05:6830:111a:: with SMTP id w26mr15065228otq.329.1617623530207;
 Mon, 05 Apr 2021 04:52:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210405003054.256017-1-aahringo@redhat.com>
In-Reply-To: <20210405003054.256017-1-aahringo@redhat.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 5 Apr 2021 07:51:59 -0400
Message-ID: <CAB_54W4Qo3C8bJH3CQ+Ce-WhByR2kMxGJDvdJ8Tv6fXSMdECag@mail.gmail.com>
Subject: Re: [PATCH RESEND wpan 00/15] net: ieee802154: forbid sec params for monitors
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Du Cheng <ducheng2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, 4 Apr 2021 at 20:31, Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> this patch series contains fixes to forbid various security parameters
> settings for monitor types. Monitor types doesn't use the llsec security
> currently and we don't support it. With this patch series the user will
> be notified with a EOPNOTSUPP error that for monitor interfaces security
> is not supported yet. However there might be a possibility in future
> that the kernel will decrypt frames with llsec information for sniffing
> frames and deliver plaintext to userspace, but this isn't supported yet.
>

cc: Du Cheng by request.

- Alex
