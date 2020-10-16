Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0813D290A19
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 18:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436519AbgJPQ5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 12:57:22 -0400
Received: from pipe.dmesg.gr ([185.6.77.131]:35988 "EHLO pipe.dmesg.gr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436511AbgJPQ5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 12:57:20 -0400
Received: from marvin.dmesg.gr (unknown [185.6.77.97])
        by pipe.dmesg.gr (Postfix) with ESMTPSA id 8111FA76E3;
        Fri, 16 Oct 2020 19:57:17 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=dmesg.gr; s=2013;
        t=1602867437; bh=Drpde3GIIkBQFdofS+4589wSdMu/opWQigp92N/bydE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ZH8HpWzqTbEML7R90g9H7BuPh4fWzF8fxLefBPDWh7ClyWFLN3COfZk5tEpcmlfWT
         mKuuWKwh0dQjHPvBh/8bwOGUq0Lk19fshb5bxVU5V/wrB5oeto18cBPbwgk6YxapLK
         yqjzNJeKxYY+inP4bxT/9SbQrvPNBEx24wOFW4XGkpqBt4gsV36eHVwecnGtI4+j7p
         4yUDrSsaMejIyhyholBOcmngOIZgB/x/XboLTGAnWfOZzPbfpgBCZ64cWlYCNX1E0A
         Sg2k6Aok4AAOxAbAvoBUj+Ujwc5n/zqoOZ7WaOa8kXrS5TTAAolQu7u9mgEtTRJD7b
         YNYd4lqsZFXdg==
Received: by marvin.dmesg.gr (Postfix, from userid 1000)
        id C8B9022BDF9; Fri, 16 Oct 2020 19:57:16 +0300 (EEST)
From:   Apollon Oikonomopoulos <apoikos@dmesg.gr>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Yuchung Cheng <ycheng@google.com>, Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: TCP sender stuck in persist despite peer advertising non-zero window
In-Reply-To: <CADVnQym2cJGRP8JnRAdzHfWEeEbZrmXd3eXD-nFP6pRNK7beWw@mail.gmail.com>
References: <87eelz4abk.fsf@marvin.dmesg.gr> <CADVnQym6OPVRcJ6PdR3hjN5Krcn0pugshdLZsrnzNQe1c52HXA@mail.gmail.com> <CAK6E8=fCwjP47DvSj4YQQ6xn25bVBN_1mFtrBwOJPYU6jXVcgQ@mail.gmail.com> <87blh33zr7.fsf@marvin.dmesg.gr> <CADVnQym2cJGRP8JnRAdzHfWEeEbZrmXd3eXD-nFP6pRNK7beWw@mail.gmail.com>
Date:   Fri, 16 Oct 2020 19:57:16 +0300
Message-ID: <878sc63y8j.fsf@marvin.dmesg.gr>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neal Cardwell <ncardwell@google.com> writes:
> On Thu, Oct 15, 2020 at 6:12 PM Apollon Oikonomopoulos <apoikos@dmesg.gr> wrote:
>> Neal, would it be possible to re-send the patch as an attachment? The
>> inlined version does not apply cleanly due to linewrapping and
>> whitespace changes and, although I can re-type it, I would prefer to test
>> the exact same thing that would be merged.
>
> Sure, I have attached the "git format-patch" format of the commit. It
> does seem to apply cleanly to the v4.9.144 kernel you mentioned you
> are using.
>
> Thanks for testing this!

We are now running the patched kernel on the machines involved. I want
to give it some time just to be sure, so I'll get back to you by
Thursday if everything goes well.

Best,
Apollon
