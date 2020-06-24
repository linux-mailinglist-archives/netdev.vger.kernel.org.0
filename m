Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093312079D7
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405297AbgFXRDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404959AbgFXRDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:03:47 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FF6C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:03:46 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id e4so3400490ljn.4
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FAuK/LOZmWSVtGMvmIuHNXUWIGFSjXCit+gGH7X/fIU=;
        b=CO7tUhluesWpHfG2hRLIeiS5a8vu7xxtO5RVRK/nIew9aPzCYHUjL6iMGz+yQyUISW
         IrWFFstN/zo2taaoYngwDzRlsBIAK+59O/tg3WIqSXm3mxn0BTV2KydSstvd4VfYFsZA
         0xkwmJqp6AdsWoM1K6wQh7WFfpQjR0eXYmeYa8ou++WGZ+zIc1gaFOD/YCYkZPtR8XwB
         I/wsKAq2m1jvFdqfIAqOFfhwDKlpnF4KCjXxjBfzAYcgvN+84iCGr8lemBY2i3fiRYfZ
         H7Zk7Q5euadU2wMYI+KJs6o2k5UGINRzf8T54KSC7vmLPCQdwmhQMTIbR/kKHVYyBldK
         zapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FAuK/LOZmWSVtGMvmIuHNXUWIGFSjXCit+gGH7X/fIU=;
        b=Mq8bjcej97rSKGghNtfrWBNmPEgg05FANZ0C2KLxzTPpjgOiH1elTLdVSC49zmfptT
         TP3DBBLaNzY83PiI5zTg3PuESLAIgAehRmZZ3Jg3RfNMvNCs2iM2t57F9ixXTAACv4Yk
         pcCP5DRCLi7atriX7gEa1/vCtqE3eWe1PdYqjBLcH3nZgZuokHuUchW7v3J9FTCZyzYR
         eBvqr3SCMQc3DuH04jMZmGwpusVRe4DcZ4AG0bAVGXNTuh8UbDUQAPzEB7xXW6sf8V0s
         pC+cCWtVwqoymDCca7GpZxRHVGGPj7aqvcPbVJbrXIejXcQa8u4ZcHsRJtdOjnJbqB/U
         v/1g==
X-Gm-Message-State: AOAM5329Q8QJrmphVl0DecTfsF9G1LeoBttFrSmaYI6nelpW0YI+YGOV
        JCLd4K7gG19570FconD1lWcXwjkzFfA3D0LrulaU7TQC
X-Google-Smtp-Source: ABdhPJyAI6EhBWtWpdeCW7noA394hL9424XJRMrYTw3IuGDmPrn2IePTtq/NReNNtCKNvPcojMwO0puy5hm1CaPIRL8=
X-Received: by 2002:a2e:95d9:: with SMTP id y25mr15113084ljh.167.1593018225112;
 Wed, 24 Jun 2020 10:03:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200616063902.15605-1-littlesmilingcloud@gmail.com> <20200618151702.24c33261@hermes.lan>
In-Reply-To: <20200618151702.24c33261@hermes.lan>
From:   Anton Danilov <littlesmilingcloud@gmail.com>
Date:   Wed, 24 Jun 2020 20:03:08 +0300
Message-ID: <CAEzD07+enUmPALNdH6CLgLW12NMoJcJ-C8gD+fJwHACLYTPZ6w@mail.gmail.com>
Subject: Re: [PATCH v2] tc: qdisc: filter qdisc's by parent/handle specification
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Stephen. Thanks for feedback.

I'm stuck in the error description. I can use just
  invarg("mutually exclusive options", *argv)

But from the user's point of view it isn't completely clear. I think it's
better to return a little bit more detailed error message. Something like this:
  if (filter_parent)
      invarg("parent is already specified", *argv);
  else if (filter_handle)
      invarg("handle is already specified", *argv);

Also I have declined the idea about adding the get command. Think the show
command is enough, and usage of the one more alias is unnecessary.

What do you think about this?

-- 
Anton Danilov.
