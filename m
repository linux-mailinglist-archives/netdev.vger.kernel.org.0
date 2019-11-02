Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B05FECF60
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 16:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfKBPIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 11:08:52 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34546 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfKBPIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 11:08:52 -0400
Received: by mail-qt1-f195.google.com with SMTP id h2so3929793qto.1
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 08:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mcyjyeo5WD7WfTXx5Ng2X1so4evuHV4V8GiglpDl1VQ=;
        b=XmN6x7X/6p6GWDZ4C4LAFG+DZtShPzLwGySyhtUf47HD6Gg+kjSJXVo9ieA+awfL6y
         KXpGd3TcdpJ8EQQbKdeWxzD8GY4dooWC2BudrcnBjYnyLSCgFXhXSEFA1XOZdFNa48Qr
         QErBYKpXEs8hxgxjM/6oWGziPCJEQ6a7J+FdsmbKcdU0RkxOpmbEQI+40YaXQSSIKcUm
         LKXia5WzKCmTnfMmV3mYR0I3gJFY5Utep6jCeN9sGBVkdXr/9rtpPnJWDxu/elTf0VR0
         qqyrBLtRId/vacL4VePmGS+kC6k3y+1z6DU0wf91tDnD+l/oQjPWdEypG/euW7f2+NwN
         8toQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mcyjyeo5WD7WfTXx5Ng2X1so4evuHV4V8GiglpDl1VQ=;
        b=RIYI76Q17i+yic0JlkVv09QszMe3IkzNcnVRsJ5kEUDNFOfIKS6ahZANKUD6V4LPwB
         XJ/kb5Jxpu6SE8OKjrL81M/jG86+yjTrcZByk3N68NraqPOBzkzXyY4CfJJKXAP33K7y
         RSxNP/xXRPOfDKLvHx9Ba7r/jLcxP0bjzZpSuFC9GxGhBQrzVeDvw9o8I1a6g/VqD8LX
         cS9+CoWRhVJsZUHcRgbdxuG5bEisPNDQk+uvdr6Fp+A1hYSM9MY1KQjStMeE9rbJhBoa
         JUcFjqmXqWf1AUtQ28DS/8vBxXOm9fv5MjP7JtBaSm3lLZvYgxXlWPpueMRfAP8qzUQw
         Y/jw==
X-Gm-Message-State: APjAAAXEZTXOU8Sxo0+KkIq0KU4G2KQ7Cms4Ht74HTkA/rdmg41cunOW
        sL3mQG1vLUJ/0++ODGsQLx7a5Ug+BSB2PXfw7BJz+g==
X-Google-Smtp-Source: APXvYqwlaOxZ+q/nRUGFIKOc0JJqqfAJQD7KYK1D1hqyIzwTOjKsvx+jZDKnZ4er2bXZRNoCmvkgrMmIKFXi/CxGFh8=
X-Received: by 2002:ac8:109:: with SMTP id e9mr5054431qtg.233.1572707331375;
 Sat, 02 Nov 2019 08:08:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191101233408.BC15495C0902@us180.sjc.aristanetworks.com> <0a03def6-3ea0-090f-048f-877700836df2@gmail.com>
In-Reply-To: <0a03def6-3ea0-090f-048f-877700836df2@gmail.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Sat, 2 Nov 2019 08:08:40 -0700
Message-ID: <CA+HUmGgDrY9A7kz7268ycAOhExA3Y1h-QhBS6xwbWYxpUODDWw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] selftest: net: add icmp reply address test
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, shuah@kernel.org,
        netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 2, 2019 at 7:34 AM David Ahern <dsahern@gmail.com> wrote:
>
> It would be better to combine both of these into a single test script;
> the topology and setup are very similar and the scripts share a lot of
> common code.

Sure, I can do that.

> Also, you still have these using macvlan devices. The intent is to use
> network namespaces to mimic nodes in a network. As such veth pairs are a
> better option for this intent.
>

I am only using macvlans for N1 in the ipv6 test, where there are 3 nodes.
How do I use veths for that?

Thanks,
Francesco
