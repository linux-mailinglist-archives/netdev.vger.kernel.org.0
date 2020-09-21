Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB01273248
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 20:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbgIUSyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 14:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgIUSyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 14:54:18 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485FAC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 11:54:18 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id gr14so19320740ejb.1
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 11:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Lp2L3xp72qIl8y0rjVI4FfmDoT1ZKIwNV26eaZdcrkI=;
        b=tjeFey89dwnF23zqVGcfBru2lcQ14ocjhk9zuqRhgF4+vQ6DqJvLLw5apb6EgiPZ9Q
         sO0/7ut5kcqKU10bWaFGT7sdm7e1sxY+ht1I7ri/KUCkjtbCxThG29CDn34r5JJL7thi
         w/Z/KiNwJV38esFVRT+dbB8+UkE7q3WZ1OXbla2Pi3ZLxllBAQp2M5WUUNJI/JYPwiL7
         iEiOy3U3CTbx/cIvf+4pxS7eqCONM224+NjqNJoi8T2ofYP+gGcxuS3xPH/+cCpGVG+5
         bQR1/3DDRutCVVAPUCODo/E63E+G1DDGvhP/YsBSdDsVnPYeNGs0QUNI9pNgE/7+zAy8
         arTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=Lp2L3xp72qIl8y0rjVI4FfmDoT1ZKIwNV26eaZdcrkI=;
        b=qpYcQ6gVcGCl3N5u4jE6V8GPm7nX734zOFJmTrqmueXPRkRaq5VA40hSNxadNk0FJc
         OBhTZ9efcNe4EV2d+zGMd+ObWXPz91JclBao9N1nOkwW53gEp+MKBEed667AgB+7VGe7
         19Zpx2YxGmo4y4QPXOHhNLM/PzmMw7Q/x+u0JDe3CaY2p2opBfUpaNLQf1/WyeGbyfI6
         ZrvfBHg51D/AHW2DVwLljOCpS/nGn1JU8FAN/x7Y9mz4+wIiFz/6pNSHEbn+L8cs15Fs
         VnHLtzrPxQDtSsYx4jm2k84FsoIwE1VV7MM7f68RId3AMEi2UNad/AE6oCZitAeAxwSM
         s1Aw==
X-Gm-Message-State: AOAM530IZJm6tsUwuMep9IpIchf+TvgO2ePRrjBJQbqTricWT9Fb1iZj
        aGM2QhvA2tEpcT359Jv+s5sdY2RN6ChTfwvhIBE=
X-Google-Smtp-Source: ABdhPJzL9V+uhWIGTgVFwrbrokOoG8CbIg5Vi3k4qTW5nzuWvbMTJvcRKVGv/gTHhd6ljdSlqkElDwzm0bGya1eFG8Q=
X-Received: by 2002:a17:906:46c9:: with SMTP id k9mr918433ejs.38.1600714456878;
 Mon, 21 Sep 2020 11:54:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6402:1118:0:0:0:0 with HTTP; Mon, 21 Sep 2020 11:54:16
 -0700 (PDT)
Reply-To: mrsmariapatricia927@gmail.com
From:   Mrs Maria Patricia <gabrieledga71@gmail.com>
Date:   Mon, 21 Sep 2020 11:54:16 -0700
Message-ID: <CAKPJXAUv+pEpn9Jhj7ogEZp5q+VRueX4BDpO-iwfmx+4dAODbQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0gDQropqrmhJvjgarjgovlj4vkurrjgIHjgYLjgarjgZ/jga/np4Hjga7mnIDlvozjga7jg6Hj
g4Pjgrvjg7zjgrjjgavov5Tkv6HjgZfjgarjgYvjgaPjgZ/jgYvjgIHjgYLjgarjgZ/jga/jgZ3j
gozjgpLlj5fkv6HjgZfjgb7jgZvjgpPjgafjgZfjgZ/jgYvvvJ8NCg0KTXkgRGVhciBGcmllbmQg
LHlvdSBkaWQgbm90IHJlc3BvbmQgdG8gbXkgbGFzdCBtZXNzYWdlIG9yIHlvdSBkaWQgbm90DQpy
ZWNlaXZlIGl0ID8NCg==
