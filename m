Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA6FA4FAE6
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 11:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfFWJVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 05:21:12 -0400
Received: from mail-ed1-f45.google.com ([209.85.208.45]:43648 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfFWJVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 05:21:11 -0400
Received: by mail-ed1-f45.google.com with SMTP id e3so16722357edr.10
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 02:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=/uWcZHCmpVkfXg6OWMzZibyf15ExAXt+guSHN0vkh/A=;
        b=ZPRqbptm3ZJdwV9LI7lmFMX39Y0ZnBHupNFizotV+MsM0RVP68hIXTUWQZdVeuDJvO
         q+gwPs9BBnQAAVxCrMzJzJGRqBOBWPksKxTpS7Xqo/V8MUt5kpeodL7+acIU2q2NYICk
         B02G6a1GrySDs0szsy1I6QBqxMxRNAb/kUz8LZK87k3eg/DEXZ+DCLAfeJct/0N8fg/t
         F+s09QnMeqYmSyUPyM8gXyZhang8oPR5nQ6p+aDQ7uydrq6LdSIuHamvC79kvJauUVUV
         NKgN/AjGJtXHB0aq5VtOuJR+EyInd6uZgVjVd30g18hgaAyxp1488t5EH7zVsPJxndHK
         YFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=/uWcZHCmpVkfXg6OWMzZibyf15ExAXt+guSHN0vkh/A=;
        b=WCtLCwC/vrTjhtYRVExaZgueDwqBXedPiGBMTMtb/HxBYky10LBfuOISKfM18qf5Mw
         bFJwi4YD/w5PNNRGAqsX6qVS50q0otP8OmB5mm5RSzdv/nMru/k8kILaK6es6bYrT3Ve
         DZ5mFfdJS+1sqhOj9jkvlLlEpI/cHwRRESZYADSu2PPRvyqbOg8oeoyqIogjUFx+DxZw
         ggy26e5qUoSA7SRu3kNPHVwKzh/CIBdgH8PAQoGl/X2oFIRjZn3EydEiUJ7f0j+cwu35
         gwAsumlb0dsOM8Cmih391lMCv831V3ZciPE3jBGIy6Rw34q/l4BR/p8QNGN+EvtgVJY+
         Iqhg==
X-Gm-Message-State: APjAAAX/IgUN14fmIvwmzpPRfy1gvzDq6cXcbd5jgVnbnLoCNcTEs/qL
        Xez/h2wFAOt9hy1IZ0KXF+edSDNlj94=
X-Google-Smtp-Source: APXvYqzz1zjf3CGtemU+ygB1owFHcye9at8xgaK2Of9VsNvlU8bwdQJVh0C5419/R3OoQaFcYYNCuA==
X-Received: by 2002:a17:906:370c:: with SMTP id d12mr3182243ejc.140.1561281669942;
        Sun, 23 Jun 2019 02:21:09 -0700 (PDT)
Received: from debian.lan ([87.116.179.41])
        by smtp.gmail.com with ESMTPSA id z12sm2566120edq.57.2019.06.23.02.21.09
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 23 Jun 2019 02:21:09 -0700 (PDT)
Message-ID: <ecf57f208369ac8b3d9cff81330cf3969ab00342.camel@gmail.com>
Subject: 
From:   Marko in1t3r Pavlovic <marko.shiva.pavlovic@gmail.com>
To:     netdev@vger.kernel.org
Date:   Sun, 23 Jun 2019 11:21:08 +0200
Content-Type: text/plain
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unsubscribe netdev=20

