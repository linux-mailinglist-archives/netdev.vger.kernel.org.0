Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7CBC15F9B9
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 23:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgBNW2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 17:28:30 -0500
Received: from mail-lj1-f179.google.com ([209.85.208.179]:41095 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727458AbgBNW23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 17:28:29 -0500
Received: by mail-lj1-f179.google.com with SMTP id h23so12391031ljc.8;
        Fri, 14 Feb 2020 14:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j9n+R3ijwPPaVq0VQpZW564wlW6k2sDGec5BmReAaN0=;
        b=Hq86TUJpAisORc4WL4/w5KI0g8NcH7qNqcfmhxXuoyCyjsg1n/gZZvxIwPeXHHQ4yB
         86r4S7pt5A7AsJnIYMYBZdTit98IcehvwQHpkAleD63Q8XxfvwNcXxEhTJORGITrpUMG
         ax8DOnB00bW5gTL3ZRryTilxp8xX3SkeIgb0KLcf85D8DGmLSufIgm2QvfY+//d21vN1
         BHB1zOcZxgEa4GBJtuvP0BHhXrMAyW3F+dR1skRUC3xGGqrCwHRyMB/eRsggkjTiZn6b
         w44VxsZJit0jucLM9qWjoVNr9bWGL2xysrQAV4Xm8Uiou62w7Hx+18aZOYd6pV2Ih6XZ
         nt8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j9n+R3ijwPPaVq0VQpZW564wlW6k2sDGec5BmReAaN0=;
        b=qAlc4fPDoIkcisAtjYqh+f171gui0pFT0oh27rxM80l1A3J/TZBOrcYnghksVlbB7M
         6qEVPU2YjzIzQ1XwZC3bDGvnB/6SWsNyf5+qbO3cS4RLOMoGVVYEVUZ/45uOJZqTWkQZ
         X0YOa9YrgkJ7cHNlg7ukcYrAIuLPUQYiH7eBiEQm3RqAMZbSNE4xcNFNun4F+9EWXRi8
         ReChvJGE2bvz8GV6L74i5BytMy/B2dkHNcTz8AISEEOKA2Ae4kY5CzO4g2drfdvq8zHs
         jC5Rb6f1AbrLBE3Hvght4ZQN6sY0D3PzwCLjFchZ0IMj9d3OMI51/fs6GN1NRANYNLKU
         JRAQ==
X-Gm-Message-State: APjAAAUutTtNhNj2FR+G8ZgJsJkZM3XAM4NMJ3pimfzOCFmpkqc6p0a9
        yI3Pi/opgAR8lKcvUupSAbrXPMpVa4LPx+WklvsslQ==
X-Google-Smtp-Source: APXvYqwf/0ZI+UGWANGHK0rw5ferPMwpijxKROZf2scwsfHVLn1sML4mLk8m9dznGJd/va+mHxDz7dwijGL+zxUYKSA=
X-Received: by 2002:a2e:a404:: with SMTP id p4mr3448041ljn.234.1581719307797;
 Fri, 14 Feb 2020 14:28:27 -0800 (PST)
MIME-Version: 1.0
References: <20200214.141328.1414498612682173242.davem@davemloft.net>
In-Reply-To: <20200214.141328.1414498612682173242.davem@davemloft.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Feb 2020 14:28:16 -0800
Message-ID: <CAADnVQLHmvSXJ8zh+VN8sYOsfk0GGp56my22DkKvg4U52q45fA@mail.gmail.com>
Subject: bpf-next is OPEN too. Re: net-next is OPEN
To:     David Miller <davem@davemloft.net>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry everyone for delay in opening.
