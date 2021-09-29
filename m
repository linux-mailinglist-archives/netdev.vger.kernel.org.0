Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C09141BEFB
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 08:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244258AbhI2GN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 02:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244235AbhI2GN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 02:13:27 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01ACC06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 23:11:46 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 97-20020a9d006a000000b00545420bff9eso1545702ota.8
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 23:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=pkOE6GhYBnoMWX9bfx7qjJXbJy9nBE9vL5NjKWq1tcQ=;
        b=M6gIb2vA7S8HUpf2tudJzfano2AHyUOoNeRV4kt1c+GJF4e3NPP4BnfGi0kqIEZAfX
         DIjAFMOVASPagCKNyy8hkJB75bCRIb9AGEA/5W0Ahjvy6yYkHpGUQ52j2Yn+ZALYHJm/
         W+AspLwGOYc2K4XL/2/NTda33S5J6ylrj/Ccm3+RnyeFnrd047HqEfWgAiZl9ct9X0zC
         JEWiZn36x/wUSZZjX6svKXgQqTrk+OJFjYQPUvgqLSCR1z50JRs7uKDvKVBcJvHQse9m
         98eYzKmzaiuiA8TW/QQPwpM05kZdwFwRZ5dARr1xT1ezRihK6OM3KP/dFoabaGt5VN2E
         0hCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=pkOE6GhYBnoMWX9bfx7qjJXbJy9nBE9vL5NjKWq1tcQ=;
        b=M/1G9BY9W5Jr4otTZXqM1Pm9SXD4Gq7T5rGh1pfdzAiqW9xvgNKldns305LByHLtxz
         fQykYjNy1If7rAB6g/QEFs6dhxj+poYU/VIP5vn7q6tyxUC7cqKPu9ttK2Nuyc+Rh8J3
         mC+Bsb8zyOZC4KoQ+3J/PXRlJBZ7DRDhGc3Xb2OLRQEPhERNrsfJJgdFnNhDimMGmfyj
         MR5Z4NGxJ7AqNjXkvWJ5fzmG6n0CCcQJmA0vruIsJH3Lxsif1SK/9Gp07yoW8kCshTYr
         bB30o8w1+8GSgcBV+FljALg+CwRm5l5wA7p5UJf271JJLCM+UTlLTFenYsPSokatBtku
         gIYQ==
X-Gm-Message-State: AOAM533v1dkJU70yBRiFdofM8VfzzRos+65FTCosD3yHYqRgKXbWurbr
        eV1Dj8BSAP56bxNzHGectO6UCGiauqkVHCKqzqQ=
X-Google-Smtp-Source: ABdhPJxWrafLPTR/w3dcmeBHIVKl5gt4bFquNYtEn+1qPL+06Qx/YbmR0eOGHBl7lQUUVwr934XUj7NafOd2Vc+GZ7w=
X-Received: by 2002:a9d:1402:: with SMTP id h2mr7024301oth.3.1632895904505;
 Tue, 28 Sep 2021 23:11:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4a:4fc8:0:0:0:0:0 with HTTP; Tue, 28 Sep 2021 23:11:43
 -0700 (PDT)
From:   Green Rodriguez <misoho505@gmail.com>
Date:   Wed, 29 Sep 2021 07:11:43 +0100
Message-ID: <CACSD0TA2rb-AZWTfxFpB82srs8ohncqNxvQjmw9N36PG4KhGvA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Do you need a loan(finance)? Contact us now. Mr. Green Rodriguez.
