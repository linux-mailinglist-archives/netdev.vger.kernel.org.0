Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9C11EAFE6
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 22:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgFAUB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 16:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgFAUB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 16:01:58 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AE9C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 13:01:57 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id a13so5837575ilh.3
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 13:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iFga/pb0neS3XDXdqtG99uZKbxGiRmHPkvnLLUXpazk=;
        b=oVVfMifS/iaYyL1SwfdfRhga36aq+TBs8qNke+JKC9nRjC+FSNno/ZknOSvYuWFixF
         hb2MSCsznwAwdAN5cRzaVYIxUOkOPB84GT3VqVFeSI9KQSmy/Px2L6kxCnA1526dHMJO
         raokDoKfeK/nzxFe/O3Dj2cnPrf2uR1mpY/GzWRNXukRY4C2fZ/A2A2kJDwv+2XUWC3E
         lhGdYqTISHNmKwLDYDFbonrtwSPAMSjjJz89+t+jnFkvuPECwTAIPO6NIM5i1vZcO8m+
         Gpo7jU0sg9fiJXaJyaHUIPsIP8LduO7UDvhk4yOCpSS9Llj68P7PfuyRdc92QyZmUGPH
         EKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iFga/pb0neS3XDXdqtG99uZKbxGiRmHPkvnLLUXpazk=;
        b=LLButtwDRWoW1rPInKxS+5qNvA7S7f/M/AfYKHwEbdJID3JJM0lUVeTTYTyJRHAwRS
         n68i9KBttlH/z2PUG+VWq9gSkPEIBRtn5vKaZgeIRRi/Hr/t68r/qpIdW9Nurd/OQogA
         RsNZOBsA/2GeF88OSXRqsqt/jUFjID00IHf+NncEEvl2N49sr7voeD2LJ5gYzdYp8Qjl
         DtwzpgYQltGUjYDeOUhrsVoS/UEuNqqgNo8yDP3OugcOG7fWNHNLx4QSm7feIUB6l34i
         cfsENst2uq0kCtAZmemID2RGMOWL2kdi2EzXa7cNPms8eeshC56D0FYbV2W9yro23KIa
         ef/w==
X-Gm-Message-State: AOAM5314srazLV51C+ehFo0wsmuLBqqmdMEWxBXCksuGNTE4Mi/IJWaW
        e4l/49b5s8BUR71eX0BVA6fPyizsAol6xRmBLh3tIg==
X-Google-Smtp-Source: ABdhPJytLnuwbPhbBgXvp/4LuWdOUy6SxnjNuBh3j4vkUu5UenOPO/FcznR3udrkQlthYkUx+tDOzTsE4h/Nb325VDo=
X-Received: by 2002:a92:5b15:: with SMTP id p21mr21746001ilb.22.1591041717382;
 Mon, 01 Jun 2020 13:01:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1590512901.git.petrm@mellanox.com> <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com>
 <877dwxvgzk.fsf@mellanox.com> <CAM_iQpX2LMkuWw3xY==LgqpcFs8G01BKz=f4LimN4wmQW55GMQ@mail.gmail.com>
 <87wo4wtmnx.fsf@mellanox.com> <CAM_iQpUxNJ56o+jW=+GHQjyq-A_yLUcJYt+jJJYwRTose1LqLg@mail.gmail.com>
 <87o8q5u7hl.fsf@mellanox.com>
In-Reply-To: <87o8q5u7hl.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 1 Jun 2020 13:01:46 -0700
Message-ID: <CAM_iQpWE7p6s-SgcG85f1r0jBUGTezZtf68toQivhvBPduC_zQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 30, 2020 at 1:55 AM Petr Machata <petrm@mellanox.com> wrote:
>
>
> Cong Wang <xiyou.wangcong@gmail.com> writes:
>
> > On Thu, May 28, 2020 at 2:48 AM Petr Machata <petrm@mellanox.com> wrote:
> >> So you propose to have further division within the block? To have sort
> >> of namespaces within blocks or chains, where depending on the context,
> >> only filters in the corresponding namespace are executed?
> >
> > What I suggest is to let filters (or chain or block) decide where
> > they belong to, because I think that fit naturally.
>
> So filters would have this attribute that marks them for execution in
> the qevent context?

If you view it as position rather than qevent, sure, we already need to
specify the "context" for tc filter creations anyway, "dev... parent ..." is
is context to locate the filter placeholders. This is why it makes sense
to add one more piece, say "position", that is "dev... parent... position...".

It is you who calls it qevent which of course looks like only belong to
qdisc's.

>
> Ultimately the qdisc decides what qevents to expose. Qevents are closely
> tied to the inner workings of a qdisc algorithm, they can't be probed as
> modules the way qdiscs, filters and actions can. If a user wishes to
> make use of them, they will have to let qdiscs "dictate" where to put
> the filters one way or another.

For a specific event like early drop, sure. But if we think it generally,
"enqueue" has the same problem, there are a few qdisc's don't even
support filtering (noop). We can just return ENOSUPP anyway.
