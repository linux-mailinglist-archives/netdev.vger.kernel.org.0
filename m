Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6193C34CEC3
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhC2LWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbhC2LWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:22:03 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB328C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:22:02 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id z6-20020a1c4c060000b029010f13694ba2so6464362wmf.5
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=5MIwhS85Z9/AQjgrIoWIgdSOGpc3DypMfRDAUXRDC0Q=;
        b=vBSUDG8dTD4R5wmFnXsN5Ygyunxv+E4ZOAJEPQBLydO2QYaCw/8PpgKyRRpna5Ya7J
         a7QgDLra921kSFu35AHB8H8tiBLzX2FghJvjjL5X73moD53/CKUlQSjaGrBnmOxg7qcn
         ch7BVxwAqP/dLf0TkN0UuFOQGBtvGxUIYHRca0JeD7DudlEPjzWBA07N2pE+dRorpDSw
         eMOTVG9xGuMZHqdJ0u5mBeQfbEPRQQrQ2PxZitI7kOD+Rbu/zQKj3L29zmm1sWXkrmX6
         yraJbXCa1pJuVCytyq6P1e1dvZH7sAZQTCs8e5UvbTPSd38WyXHHvxE9ptXh7mDdPMHr
         7AnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=5MIwhS85Z9/AQjgrIoWIgdSOGpc3DypMfRDAUXRDC0Q=;
        b=gfHs+23G2y7WUUrRzzceg/sueSeiifjEUWS7ZdDp+MOZpqDLli3Q2ouU7OnbCHO1au
         fOvnK19YR/VJnJ6rC5STeKSO0XURG/s/iCJqQAXxPPDqI0rM2Wppng/f97CH0TAf4yir
         uViu4G2vtfbKkAgBh6WcuubBX3NxwOcjkSDCKgAzLhgBOOghRmIN0wXk9kczA+BqxeMz
         No64uM6PJw7g0mezxMNPScNQPtholHmpCKgqrvMqbUtcocbLR1DLXUuoSFUxlLTc6XD9
         sPi/2BYgBwljt3lOA1Kt69bw4PpDHnk0wRfk9bgMiDzk9Pvw/qQ8NsB+cZLEXt00v6Lc
         N4+w==
X-Gm-Message-State: AOAM533/YBE/Nv5QdXXTjzwG5FQhpLhpa4nYWX91kjxQXsNlAeotS5Tz
        I7IvXuNSa8XFGoIdYWx12gTLTA5l9Yj8PAKmEGjIjHaePDsQGb74
X-Google-Smtp-Source: ABdhPJyXN2AiEJcCi/21gzDM+OGA85ce9BYlxOJbMUd1PiarETtydoTWhx+ZQa5nPiSh1ciuSzz7nwL20m4GLjAGkp8=
X-Received: by 2002:a1c:e341:: with SMTP id a62mr25248575wmh.152.1617016921323;
 Mon, 29 Mar 2021 04:22:01 -0700 (PDT)
MIME-Version: 1.0
From:   RAJESH DASARI <raajeshdasari@gmail.com>
Date:   Mon, 29 Mar 2021 16:51:50 +0530
Message-ID: <CAPXMrf8UR+h5A8ZG9YAUdwwgk92_kpVKxYKj+TQJS-KA8-q-Ww@mail.gmail.com>
Subject: Re: Permission denied error when trying to create vlan on SRIOV VFs
 in container
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi ,

We have created 19 vfs per interface on the host side.

cat  /sys/class/net/eth2/device/sriov_numvfs
19
cat  /sys/class/net/eth1/device/sriov_numvfs
19

ethtool -i eth2
driver: ixgbe
version: 4.4.0-k
firmware-version: 0x80000843
expansion-rom-version:
bus-info: 0000:09:00.1
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: no

kernel version : 4.9.249 and x86_64 architecture.

We launch 18 pods and each pod will have 2 interfaces eth1 and eth2
mapped from these 38 virtual sriov interfaces.

Inside each pod , we are creating vlans from the range[2 to 4094],
when this creation is happening parallelly on all the pods , we see
that vlans creation is failing randomly on all the pods with RTNETLINK
answers: Permission denied Error.

command used to create the vlan in all the 18 pods is

ip link add link eth2 name mPlaneVlanX type vlan id X -> X is range(2.4094)

Could you please let us know if there are any limitations with the
numbers of vlans that can be created on the VF interfaces, or is it
any known issue ? Could you please help me on this.

Regards,
Rajesh.
