Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B0316EB71
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730941AbgBYQak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:30:40 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34396 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730645AbgBYQak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 11:30:40 -0500
Received: by mail-ot1-f66.google.com with SMTP id j16so112998otl.1
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 08:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JLcSuwAaGtSKoOE9+jOSv0FWdutoyCod4itJyeylRj8=;
        b=E2gNeNZoUa/7s0aSmubo4FCqMM1rso5Mmg78dyosPk2Am20kaqXXlQZkEf77NNfNM0
         ZvhBXCsvr9stNSwpVdTFBco0paNoEAA9gb7eDcO0gRP+N6Z4KBkKl1PyKq+yzE5g+2KN
         wV2qDrKXwFJoWtibMsElyfvr4R1aUHaEy3UVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JLcSuwAaGtSKoOE9+jOSv0FWdutoyCod4itJyeylRj8=;
        b=ucEjw0wGALXiyVz4paIdzHJZqIs65h4xYZcf7pD0bkAzAjCF0/RglzhwZBidVQDFZy
         Z0MKJarmWWvvMznB9+RrwnW45+kkkjO7MB7ZR840qjGmkMiw9Ew3uzAMDjnm0F2UeqY3
         U0mNcy+RYrtz9vaoZ3URNXU9S0t10UIWtH5TnSBzG2xFtA9YhinxOKz9eEiGhO8PcBS8
         5r9YIyklWy0mDU96Olsg5irdrVa4Gl5n3FvbnYictMEepzeNWuuO2qC95iPCB8njUFBT
         aX3lZ/baIF6fnDkERC2GrN4Ntrceud1/AMzU2QKMlBO6cg0QPo8BI7zk7CdCSv6+URaQ
         JeCA==
X-Gm-Message-State: APjAAAX1lQlUKMzw1tj1rHbbp93FCJLGQeBWAHAeE831UW8Zv5YkWWk9
        UOf7jNE06u8W1bFADxzSqZvQkOp2NISveiZg3jpeIQ==
X-Google-Smtp-Source: APXvYqxqz/JMyDBOACvHmW2Vrj9I+0kWTjG+YBSIKpQvtiy1+h6thDtzLUrBTECRPdGg1EAKWCWv2PLNKD8HxUv44Sc=
X-Received: by 2002:a05:6830:114f:: with SMTP id x15mr44086248otq.291.1582648239042;
 Tue, 25 Feb 2020 08:30:39 -0800 (PST)
MIME-Version: 1.0
References: <20200224232909.2311486-1-jonathan.lemon@gmail.com>
 <20200224.153254.1115312677901381309.davem@davemloft.net> <0C3291B2-E552-420F-B31F-F18C6F5FE056@gmail.com>
In-Reply-To: <0C3291B2-E552-420F-B31F-F18C6F5FE056@gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Tue, 25 Feb 2020 08:30:27 -0800
Message-ID: <CACKFLik4+JCV+DWTnmh_UtenmYYFX8yLw4LoaCC-6yLEkX4pzQ@mail.gmail.com>
Subject: Re: [PATCH] bnxt_en: add newline to netdev_*() format strings
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 8:16 AM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>
>
> On 24 Feb 2020, at 15:32, David Miller wrote:
>
> > Jonathan, why did you post three copies of this same patch?
>
> Er, what?
>
> I ran "git send-email --dry-run" to confirm the email addresses were
> correct,
> (mistyped yours) then ran "git send-email" once (without --dry-run) to
> actually
> send the message.
>
> There should be a single posting on the list, are you telling me
> otherwise?

Yes, I saw 3 copies too.

The patch looks good though.  Thanks.

Acked-by: Michael Chan <michael.chan@broadcom.com>
