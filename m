Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2AFE108050
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 21:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKWUPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 15:15:51 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44248 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKWUPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 15:15:51 -0500
Received: by mail-ot1-f65.google.com with SMTP id c19so9195922otr.11
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 12:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p77pe64Y0IrNMjwbh8fu9x8hpkTMf7kI+K4bv+/xRuo=;
        b=F0V9hRN5YCZJSTeXjLSivKkv3LhnITq05AYEUEMZ+WwOrj3l9AE3ak+SLi+0po4nrW
         bxWE3zCnlPVGx/Bqm7Ktsww4yP4Ll6RdehhIlFv4YDcX2u+vnMUFuYoFv0v9eJzyqjCO
         1m27MF1mwnAADIPJ9x1FTvxc2JoGw/MVNlQ1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p77pe64Y0IrNMjwbh8fu9x8hpkTMf7kI+K4bv+/xRuo=;
        b=R4SDFB87TdY4s1+p+Xr62PnwCMssBrgpSRVzJy2MTeCtmvi+XSzM08b93oQqPTVkJw
         jR3f9eaP8VD85OyycKESrNOb2wJNKnc5jKJtiW7+s/ZldLkiS6lZsXCIY5w8lGp3NK4A
         QNTjNf/TXMEMlBr91MAa68WA09z/Om+aHJRAfAiybwyenE3X2ybyuDC+UIQAciooqsp/
         mGbRDfD68/FPR/j+UCBYTawkEKLH0YXZ78dohhIJ/79SZXv4wXqYmIRyI7DPwOUOkyAq
         V1fG+juk7EsUHnFhASwom1UPR+OWg7fNYRemUqPVTdjNJxNyAVglc2sBbK3bhI7xupiQ
         SD3g==
X-Gm-Message-State: APjAAAUacxKYE2r/KqDQOjfqOkDqx1DMr2cAXLcEGWlDPrdSgmHbL2z5
        m5a9AKyptya8w+XTr/e/sGqXmeUJ/aBawV1y6qqYYg==
X-Google-Smtp-Source: APXvYqzrohmDpzkTeWSZRBCa2H6/eeEuhZplO8OZI6UdGoIMnTu4i4ZBcZnLd+jQxfFvYLnGHOURluffZXjnQA/1CXE=
X-Received: by 2002:a05:6830:1313:: with SMTP id p19mr8184192otq.246.1574540150303;
 Sat, 23 Nov 2019 12:15:50 -0800 (PST)
MIME-Version: 1.0
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
 <1574497570-22102-16-git-send-email-michael.chan@broadcom.com> <20191123115506.2019cd08@cakuba.netronome.com>
In-Reply-To: <20191123115506.2019cd08@cakuba.netronome.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sat, 23 Nov 2019 12:15:39 -0800
Message-ID: <CACKFLinKFLT5WJ__nNhwqOfOFO9jH9fOKmi9S_GSucecbmX0eA@mail.gmail.com>
Subject: Re: [PATCH net-next 15/15] bnxt_en: Add support for devlink info command
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 11:55 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:

> What's a board package? What HW people call a "module"? All devlink info
> versions should be documented in devlink-info-versions.rst.
>
> What are the possible values here? Reporting free form strings read
> from FW is going to be a tough sell. Probably worth dropping this one
> if you want the rest merged for 5.5.
>

Sure, we can drop this one for now.  Do you want me to resend, or can
you apply just the 1st 14 patches?
